# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative 'similarity_cache'

class SimilarityCalculator

	DEFAULT_MIN_SIMILARITY = 0.86
	def initialize(id_to_user, movies_count, min_sim = DEFAULT_MIN_SIMILARITY)
		@id_to_user = id_to_user
		@max_user_distance = (((5 - 1) ** 2) * movies_count) ** 0.5
		@min_sim = min_sim
		@cache = SimilarityCache.new()
	end

	def similarity(user1_id, user2_id)
		user1, user2 = @id_to_user[user1_id], @id_to_user[user2_id]
		sim = @cache.get_sim(user1, user2)
		return sim if !sim.nil?

		@cache.put_sim(user1, user2, calc_similarity(user1,user2))
	end

	# TODO remove the option to enter another min_sim then defined in this object via
	# @min_sim
	def most_similar(user_id, min_sim = @min_sim, sort=false)
		user = @id_to_user[user_id]
		most_sim = @cache.get_most_sim(user)
		return most_sim if !most_sim.nil?

		@cache.put_most_sim(user, calc_most_sim(user_id,min_sim,sort))
	end

	private

	def calc_similarity(user1, user2)
		# With n movies in total regard each user as a point in n dimensional space. The
		# user's rating for a particular movie is the coordinate in the corresponding
		# dimension. If the user did not rate the movie at all, the algorithm assumes the
		# neutral rating '3'. The distance between the two points resulting from two
		# users is inverse proportional to the similarity of these two users.

		square_sum = 0.0

		# performance tweak: iterating over the union of movies rated by one of the
		# compared users (instead of iterating over all movies). Mathematically the
		# movies which have not been rated by any of the two users would contribute the
		# coordinate '3' for both and thus 0 for the distance between the two resulting
		# points. Therefore these movies can be skipped.
		movies_union = user1.rated_movies | user2.rated_movies
		movies_union.each do |movie|
			rating1 = user1.rating_num(movie) || 3.0
			rating2 = user2.rating_num(movie) || 3.0

			square_sum += (rating2 - rating1) ** 2.0
		end

		distance = square_sum ** 0.5
		1.0 - distance / @max_user_distance
	end

	def calc_most_sim(user_id, min_sim, sort)
		filtered = {}
		@id_to_user.values.each do |u|
			sim = similarity(user_id, u.id)
			filtered[u] = sim if u.id != user_id && sim >= min_sim
		end

		# sort the matching users in descending order regarding their requested
		# similarity
		if sort
			filtered.each_key.sort {|a, b| filtered[b] <=> filtered[a]}
		else
			filtered.keys
		end
	end
end