# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative 'file_parser'
require_relative 'popularity_calculator'

class MovieData
	
	attr_writer(:time_class, :popul_half_life_years)
	
	def initialize()
		@time_class = Time
		@popul_half_life_years = 3.0
		@popularity_desc_list = []
	end
	
	def load_data(file_path)
		parser = FileParser.new
		line_count = parser.parse(file_path)
		@id_to_user = parser.id_to_user
		@id_to_movie = parser.id_to_movie

		@max_user_distance = ((4 ** 2) * all_movies.length) ** 0.5

		calculator = PopularityCalculator.new(@time_class, @popul_half_life_years)
		@popularity_desc_list = calculator.insert_popularities(all_movies)

		line_count
	end

	def all_users
		@id_to_user.values
	end

	def all_movies
		@id_to_movie.values
	end

	def user(user_id)
		@id_to_user[user_id]
	end

	def movie(movie_id)
		@id_to_movie[movie_id]
	end

	def popularity(movie_id)
		movie(movie_id).popularity
	end

	def popularity_list
		# returns copy in order to avoid changes of this array
		Array.new(@popularity_desc_list)
	end

	def similarity(user1_id, user2_id)
		# With n movies in total regard each user as a point in n dimensional space. The user's 
		# rating for a particular movie is the coordinate in the corresponding dimension. If the 
		# user did not rate the movie at all, the algorithm assumes the neutral rating '3'.
		# The distance between the two points resulting from two users is inverse proportional to
		# the similarity of these two users.
		
		user1, user2 = user(user1_id), user(user2_id)

		square_sum = 0.0
		
		# performance tweak: iterating over the union of movies rated by one of the compared users
		# (instead of iterating over all movies). Mathematically the movies which have not been
		# rated by any of the two users would contribute the coordinate '3' for both and thus 0
		# for the distance between the two resulting points. Therefore these movies can be skipped.
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
		sorted_users = all_users.sort {|a, b| similarity(user_id, b.id) <=> similarity(user_id, a.id)}
		result = []

		# sorted_users[0].id == user_id, starting with index == 1
		1.upto(top_n) do |index|
			break if index + 1 > sorted_users.length
			result << sorted_users[index]
		end

		result
	end
end