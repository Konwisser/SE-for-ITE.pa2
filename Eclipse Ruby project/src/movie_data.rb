require_relative 'file_parser'
require_relative 'popularity_calculator'
require_relative 'similarity_calculator'
require_relative 'rating_predicter'
require_relative 'movie_test'

# This class represents a whole movie data set with a list of movies, a list of
# users and a list of movie ratings by individual users. The Rating objects store
# references to User and Movie objects which define the rating, the User objects
# store references to all movies rated by the corresponding user and the Movie
# objects store references to all users who rated the corresponding movie.
#
# This class also contains methods for reading in the data from files and
# calculating derived information such as movie popularity, user similarity, and
# rating predictions.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MovieData

	# the default (relative) file path to the directory containing the rated movie
	# data set (the path assumes the Eclipse project's root as working directory)
	DEFAULT_DIR_PATH = 'data/ml-100k'

	# the file containing all ratings as default data source
	DEFAULT_DATA_FILE = 'u.data'

	# the file extensions of the base-part of a any base-test data set pair
	BASE_FILE_EXTENSION = 'base'

	# the file extensions of the test-part of a any base-test data set pair
	TEST_FILE_EXTENSION = 'test'

	# Sets the PopularityCalculator object to be used for popularity calculations in
	# this MovieData object
	attr_writer :pop_calc
	# Creates a new MovieData object.
	# data_dir_path::
	#	optional file path to the directory containing the rated movies data set; if
	# 	omitted DEFAULT_DIR_PATH is used
	# base_test_pair::
	#	optional indication of the base-test pair to be used; e.g. +u1+ would make
	#	this object read in +u1.base+ and then try to predict the ratings in
	#	+u1.test+; if omitted DEFAULT_DATA_FILE will be read in from +data_dir_path+
	def initialize(data_dir_path = DEFAULT_DIR_PATH, base_test_pair = nil)
		@data_dir_path = data_dir_path
		@base_test_pair = base_test_pair

		@pop_calc = PopularityCalculator.new()
		@popularity_desc_list = []
	end

	# Reads in the data and stores references to resulting User, Movie, and Rating
	# objects. Also establishes corresponding references between these objects.
	# file_path::
	#	optional file path defining the file to be read in; if omitted the parameters
	# 	used in MovieData::new determine the file to be read in
	# returns::
	#	the number of read in lines which should correspond to the number of created
	# 	Rating objects
	def load_data(file_path = nil)
		parser = FileParser.new
		line_count = parser.parse(complete_file_path(file_path))
		@id_to_user = parser.id_to_user
		@id_to_movie = parser.id_to_movie

		# can only be defined after the data is read in since the SimilarityCalculator
		# requires some data statistics during initialization
		@sim_calc = SimilarityCalculator.new(self)

		@popularity_desc_list = @pop_calc.insert_popularities(all_movies)

		line_count
	end

	# Returns a list of User objects representing all users in the read in data set.
	def all_users
		@id_to_user.values
	end

	# Returns a list of Movie objects representing all movies in the read in data
	# set.
	def all_movies
		@id_to_movie.values
	end

	# Returns the User object with the provided id.
	# user_id:: integer id of the user to be retrieved
	def user(user_id)
		@id_to_user[user_id]
	end

	# Returns a list of User objects representing all users who have rated the
	# provided movie.
	# movie_id:: integer id of the movie of interest
	def viewers(movie_id)
		movie(movie_id).ratings.map {|r| r.user_obj}
	end

	# Returns the Movie object with the provided id.
	# user_id:: integer id of the movie to be retrieved
	def movie(movie_id)
		@id_to_movie[movie_id]
	end

	# Returns a list of Movie objects representing all movies which have been rated
	# by the provided user.
	# movie_id:: integer id of the user of interest
	def movies(user_id)
		user(user_id).rated_movies
	end

	# Returns a numeric number indicating the popularity of a given movie - a bigger
	# number means a greater popularity.
	# movie_id:: the numeric id of the movie of interest as provided in the data set
	def popularity(movie_id)
		movie(movie_id).popularity
	end

	# Returns a list of all known movies, sorted by popularity descending order.
	# returns:: a list of Movie objects
	def popularity_list
		# returns a copy in order to avoid changes of this array
		Array.new(@popularity_desc_list)
	end

	# Returns the similarity of two given users.
	# user1_id:: the numeric id of the first user as given in the data set
	# user2_id:: the numeric id of the second user as given in the data set
	# returns::
	#	a numeric value between 0.0 and 1.0 with 1.0 as maximum similarity
	def similarity(user1_id, user2_id)
		@sim_calc.similarity(user1_id, user2_id)
	end

	# Returns a list of users who have the most similarity to the given user.
	# user_id:: the numeric id of the user of interest as provided in the data set
	# returns:: a list of User objects
	def most_similar(user_id)
		@sim_calc.most_similar(user_id)
	end

	# Returns the integer rating of the given user for the given film. If no such
	# rating is known +0+ is returned.
	# user_id:: the numeric id of the user of interest as provided in the data set
	# movie_id:: the numeric id of the movie of interest as provided in the data set
	def rating(user_id, movie_id)
		user(user_id).rating_num(movie(movie_id)) || 0
	end

	# Predicts the rating of the given user for the given movie based on the
	# knowledge gained from the read in data set.
	def predict(user_id, movie_id)
		RatingPredicter.new(@sim_calc).predict(user(user_id), movie(movie_id))
	end

	# Runs a prediction accuracy test where the base data set is used to predict the
	# test data set. In order to run this test this MovieData object must have been
	# initialized with base-test pair indication.
	# k::
	#	integer value defining how many lines of the test data set should be used for
	#	this test
	# returns:: a MovieTest objects containing the ideal and the calculated values
	def run_test(k)
		path = "#{@data_dir_path}/#{@base_test_pair}.#{TEST_FILE_EXTENSION}"
		pars = FileParser.new
		pars.parse(path, k)

		pred = RatingPredicter.new(@sim_calc)

		test = MovieTest.new

		pars.ratings.each do |r|
			# The user and movie objects from this MovieData object do not store the rating
			# to be predicted, the objects in pars.rating do. Therefore the users and movies
			# with the same id as the ones in rating are retrieved from this MovieData
			# object.
			# This ensures a fair testing.

			in_db_user, in_db_movie = user(r.user_obj.id), movie(r.movie_obj.id)
			test.add_result(r, pred.predict(in_db_user, in_db_movie))
		end

		test
	end

	# Defines the minimum similarity a user A must have to a user B in order to
	# appear in the list of most similar users to B.
	# min_sim:: a numeric value between 0.0 and 1.0
	def min_similarity=(min_sim)
		@sim_calc.min_sim = min_sim
	end

	private

	def complete_file_path(file_path)
		return file_path if !file_path.nil?
		return "#{@data_dir_path}/#{DEFAULT_DATA_FILE}" if @base_test_pair.nil?
		return "#{@data_dir_path}/#{@base_test_pair}.#{BASE_FILE_EXTENSION}"
	end
end