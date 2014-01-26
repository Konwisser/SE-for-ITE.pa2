class SimilarityCalculator
	
	def initialize(id_to_user, movies_count)
		@id_to_user = id_to_user
		@max_user_distance = (((5 - 1) ** 2) * movies_count) ** 0.5
	end

	def similarity(user1_id, user2_id)
		# With n movies in total regard each user as a point in n dimensional space. The
		# user's rating for a particular movie is the coordinate in the corresponding
		# dimension. If the user did not rate the movie at all, the algorithm assumes the
		# neutral rating '3'. The distance between the two points resulting from two
		# users is inverse proportional to the similarity of these two users.

		user1, user2 = @id_to_user[user1_id], @id_to_user[user2_id]

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

	def most_similar(user_id, top_n = 10)
		# sort descending (biggest number -> most similar)
		sorted_users = @id_to_user.values.sort do |a, b| 
			similarity(user_id, b.id) <=> similarity(user_id, a.id)
		end
		
		result = []

		# sorted_users[0].id == user_id, starting with index == 1
		1.upto(top_n) do |index|
			break if index + 1 > sorted_users.length
			result << sorted_users[index]
		end

		result
	end
end