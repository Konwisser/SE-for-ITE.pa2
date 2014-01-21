class User
	attr_reader :id

	def initialize(user_id)
		@id = user_id
		@movie_to_rating_num = {}
	end

	def add_rating(rating_obj)
		@movie_to_rating_num[rating_obj.movie_obj] = rating_obj.rating_num
	end

	def rating_num(movie_obj)
		@movie_to_rating_num[movie_obj]
	end

	def rated_movies
		@movie_to_rating_num.keys
	end

	def to_string
		"User (id = #{@id}, ratings_count: #{@movie_to_rating_num.keys.length})"
	end
end

class Movie
	POPUL_HALF_LIFE_YEARS = 3.0
	POPUL_EXP_BASE = 0.5 ** (1.0 / POPUL_HALF_LIFE_YEARS)
	SECONDS_IN_YEAR = 3600.0 * 24.0 * 365.25
	private_constant :POPUL_HALF_LIFE_YEARS, :POPUL_EXP_BASE, :SECONDS_IN_YEAR

	attr_reader :id, :popularity

	def initialize(movie_id)
		@id = movie_id
		@ratings = []
		@popularity = 0
	end

	def add_rating(rating_obj)
		@ratings << rating_obj
		@popularity += calc_popularity_addition(rating_obj)
	end

	def to_string
		"Movie (id = #{@id}, ratings_count = #{@ratings.length}, popularity = #{@popularity})"
	end

	private
		# A today's rating would the macimum to the film's popularity, which is 1.
		# A rating which is POPUL_HALF_LIFE_YEARS old would add half of it, means 0.5.
		# With t as time in years, the popularity addition P is
		# P(t) = 1 * POPUL_EXP_BASE ^ t
		def calc_popularity_addition(rating_obj)
			now_seconds = Time.now.to_i
			rating_seconds = rating_obj.timestamp.to_i
			diff_years = (now_seconds - rating_seconds) / SECONDS_IN_YEAR
			POPUL_EXP_BASE ** diff_years
		end
end

class Rating
	attr_reader :user_obj, :movie_obj, :rating_num, :timestamp

	def initialize(user_obj, movie_obj, rating_num, timestamp_num)
		@user_obj = user_obj
		@movie_obj = movie_obj
		@rating_num = rating_num
		@timestamp = Time.at(timestamp_num)
	end
end


class MovieData

	MOST_SIMILAR_TOP_N = 10

	def initialize
		@id_to_movie = {}
		@id_to_user = {}
		@popularity_desc_list = []
	end

	def load_data(file_path)
		line_count = 0
		File.readlines(file_path).each do |line|
			read_line(line)
			line_count += 1
		end

		@popularity_desc_list = @id_to_movie.values.sort {|a, b| b.popularity <=> a.popularity}

		@max_user_distance = ((4 ** 2) * all_movies.length) ** 0.5

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
		# puts "", "calculating similarity between #{user1.to_string} and #{user2.to_string}"

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
		sim = 1.0 - distance / @max_user_distance
		# puts "similarity: #{sim}"
		sim
	end

	def most_similar(user_id)
		# sort descending (biggest number -> most similar)
		sorted_users = all_users.sort {|a, b| similarity(user_id, b.id) <=> similarity(user_id, a.id)}
		result = []

		# sorted_users[0].id == user_id, starting with index == 1
		1.upto(MOST_SIMILAR_TOP_N) do |index|
			break if index + 1 > sorted_users.length
			result << sorted_users[index]
		end

		result
	end

	private

		def read_line(line)
			user_id_str, movie_id_str, rating_num_str, timestamp_num_str = line.split("\t")
			
			user_obj = get_or_create_user(user_id_str.to_i)
			movie_obj = get_or_create_movie(movie_id_str.to_i)

			rating_obj = Rating.new(user_obj, movie_obj, rating_num_str.to_i, timestamp_num_str.to_i)
			user_obj.add_rating(rating_obj)
			movie_obj.add_rating(rating_obj)
		end

		def get_or_create_user(user_id)
			user = @id_to_user[user_id] || User.new(user_id)
			@id_to_user[user_id] = user
		end

		def get_or_create_movie(movie_id)
			movie = @id_to_movie[movie_id] || Movie.new(movie_id)
			@id_to_movie[movie_id] = movie
		end
end