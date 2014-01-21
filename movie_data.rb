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
	POPUL_HALF_LIFE_YEARS = 5.0
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

	private
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

	def load_data
		f = File.open(U_DATA_FILE_PATH)
		
		while (line = f.gets)
			user_id, movie_id, rating_num, timestamp_num = line.split("\t")
			
			user_obj = User.new(user_id)
			movie_obj = Movie.new(movie_id)

			rating_obj = Rating.new(user_obj, movie_obj, rating_num, timestamp_num)
			user_obj.add_rating(rating_obj)
			movie_obj.add_rating(rating_obj)
		end
	end

	def popularity(movie_id)
		# TODO
	end
end