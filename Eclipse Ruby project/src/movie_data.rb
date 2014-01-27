# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative 'file_parser'
require_relative 'popularity_calculator'
require_relative 'similarity_calculator'

class MovieData

	DEFAULT_DIR_PATH = 'data/ml-100k'
	DEFAULT_DATA_FILE = 'u.data'
	BASE_FILE_EXTENSION = 'base'
	TEST_FILE_EXTENSION = 'test'

	attr_writer(:time_class, :popul_half_life_years)
	def initialize(data_dir_path = DEFAULT_DIR_PATH, base_test_pair = nil)
		@data_dir_path = data_dir_path
		@base_test_pair = base_test_pair

		@time_class = Time
		@popul_half_life_years = 3.0
		@popularity_desc_list = []
	end

	def complete_file_path(file_path)
		return file_path if !file_path.nil?
		return "#{DEFAULT_DIR_PATH}/#{DEFAULT_DATA_FILE}" if @base_test_pair.nil?
		return "#{DEFAULT_DIR_PATH}/#{@base_test_pair}.#{BASE_FILE_EXTENSION}"
	end

	def load_data(file_path = nil)
		parser = FileParser.new
		line_count = parser.parse(complete_file_path(file_path))
		@id_to_user = parser.id_to_user
		@id_to_movie = parser.id_to_movie

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

	def movie(movie_id)
		@id_to_movie[movie_id]
	end

	def popularity(movie_id)
		movie(movie_id).popularity
	end

	def popularity_list
		# returns a copy in order to avoid changes of this array
		Array.new(@popularity_desc_list)
	end

	def similarity(user1_id, user2_id)
		SimilarityCalculator.new(@id_to_user, all_movies.length).
		similarity(user1_id,user2_id)
	end

	def most_similar(user_id, min_sim = SimilarityCalculator::DEFAULT_MIN_SIMILARITY)
		SimilarityCalculator.new(@id_to_user, all_movies.length).
		most_similar(user_id, min_sim)
	end

	def rating(user_id, movie_id)
		@id_to_user[user_id].rating_num(movie(movie_id)) || 0
	end

	#	def predict(user_id, movie_id)
	#		rating(user_id, movie_id) ||
	#	end
end