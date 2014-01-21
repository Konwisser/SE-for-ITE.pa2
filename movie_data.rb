class User
	attr_reader :id, :ratings

	def initialize(user_id)
		@id = user_id
		@ratings = []
	end

	def add_rating(rating_obj)
		@ratings << rating_obj
	end
end

class Movie
	POPUL_HALF_LIFE_YEARS = 3.0
	POPUL_EXP_BASE = 0.5 ** (1.0 / POPUL_HALF_LIFE_YEARS)
	SECONDS_IN_YEAR = 3600.0 * 24.0 * 365.25
	private_constant :POPUL_HALF_LIFE_YEARS, :POPUL_EXP_BASE, :SECONDS_IN_YEAR

	attr_reader :id, :ratings, :popularity

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

	U_DATA_FILE_PATH = "ml-100k/u.data"

	def initialize
		@id_to_movie = {}
		@id_to_user = {}
		@popularity_max_to_min_array = []
	end

	def load_data
		f = File.open(U_DATA_FILE_PATH)
		
		while (line = f.gets)
			user_id_str, movie_id_str, rating_num_str, timestamp_num_str = line.split("\t")
			
			user_obj = get_or_create_user(user_id_str.to_i)
			movie_obj = get_or_create_movie(movie_id_str.to_i)

			rating_obj = Rating.new(user_obj, movie_obj, rating_num_str.to_i, timestamp_num_str.to_i)
			user_obj.add_rating(rating_obj)
			movie_obj.add_rating(rating_obj)
		end

		@popularity_max_to_min_array = @id_to_movie.values.sort do |a, b| 
			if a.popularity > b.popularity
				-1 # a follows b
			elsif a.popularity == b.popularity
				0 # a and b are equal
			else
				1 # b follows a
			end
		end
	end

	def popularity(movie_id)
		movie(movie_id).popularity
	end

	def movie(movie_id)
		@id_to_movie[movie_id]
	end

	def popularity_list
		# returns copy in order to avoid changes of this array
		Array.new(@popularity_max_to_min_array)
	end

	private

		def get_or_create_user(user_id)
			user = @id_to_user[user_id]
			if user == nil
				user = User.new(user_id)
				@id_to_user[user_id] = user
			end
			user
		end

		def get_or_create_movie(movie_id)
			movie = @id_to_movie[movie_id]
			if movie == nil
				movie = Movie.new(movie_id)
				@id_to_movie[movie_id] = movie
			end
			movie
		end

end