require_relative 'similarity_cache'

# Author:: Georg Konwisser (mailto:software@konwisser.de)
class SimilarityCalculator

	DEFAULT_MIN_SIMILARITY = 0.86
	def initialize(movie_data, min_sim = DEFAULT_MIN_SIMILARITY)
		@cache = SimilarityCache.new()
		self.min_sim = min_sim

		@movie_data = movie_data
		@max_user_distance = (((5 - 1) ** 2) * movie_data.all_movies.length) ** 0.5
	end

	# Defines the minimum similarity a user A must have to a user B in order to
	# appear in B's most_similar list.
	# min_sim:: a numeric value between 0.0 and 1.0
	def min_sim=(min_sim)
		@min_sim = min_sim
		@cache.clear_most_sim
	end

	def similarity(user1_id, user2_id)
		user1, user2 = @movie_data.user(user1_id), @movie_data.user(user2_id)
		sim = @cache.get_sim(user1, user2)
		return sim if !sim.nil?

		@cache.put_sim(user1, user2, calc_similarity(user1,user2))
	end

	def most_similar(user_id, sort=false)
		user = @movie_data.user(user_id)
		most_sim = @cache.get_most_sim(user)
		return most_sim if !most_sim.nil?

		@cache.put_most_sim(user, calc_most_sim(user_id, sort))
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

	def calc_most_sim(user_id, sort)
		filtered = {}
		@movie_data.all_users.each do |u|
			sim = similarity(user_id, u.id)
			filtered[u] = sim if u.id != user_id && sim >= @min_sim
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