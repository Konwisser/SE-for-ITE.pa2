# Author: Georg Konwisser
# Email: software@konwisser.de

require "test/unit"

require_relative '../movie_data'
require_relative 'eclipse_test_case_workaround'
require_relative 'test_time'
require_relative 'test_helper'

class MovieDataTestSimilarity < Test::Unit::TestCase
	def test_user_to_user_similarity
		movie_data = MovieData.new
		movie_data.load_data(TestHelper::TEST_U_DATA_FILE_PATH)

		max_user_distance = ((4 ** 2) * movie_data.all_movies.length) ** 0.5

		assert_equal(movie_data.similarity(1, 2), movie_data.similarity(2, 1))
		assert_in_delta(1.0 - 2.0 / max_user_distance, movie_data.similarity(1, 2), 0.0001)
	end

	def test_most_similar_on_test_data
		movie_data = MovieData.new
		movie_data.load_data(TestHelper::TEST_U_DATA_FILE_PATH)

		list = movie_data.most_similar(1, 1.0)
		assert_equal(10, list.length, "list should contain exactly 10 most similar users")

		list.each do |user_obj|
			assert(user_obj.id > 10, "user_id #{user_obj.id} is < 11, shouldn't be in list")
			assert(user_obj.id < 21, "user_id #{user_obj.id} is > 20, shouldn't be in list")
		end

		assert_equal(0, movie_data.most_similar(2, 0.86).length)
		assert_equal(11, movie_data.most_similar(2, 0.79).length)
	end

	def test_most_similar_on_real_data
		TestHelper.new.print_header("test_most_similar_on_real_data")

		movie_data = MovieData.new
		movie_data.load_data(TestHelper::U_DATA_FILE_PATH)

		puts "the most similar users to #{movie_data.user(1)} are:"

		list = movie_data.most_similar(1)
		TestHelper.new.print_list_to_string(list, 0, list.length - 1)
	end

end