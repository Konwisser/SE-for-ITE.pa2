# Author: Georg Konwisser
# Email: software@konwisser.de

require "test/unit"

require_relative '../movie_data'
require_relative 'eclipse_test_case_workaround'
require_relative 'test_time'
require_relative 'test_helper'

class MovieDataTest < Test::Unit::TestCase
	def test_read_test_data
		movie_data = MovieData.new
		assert_equal(97, movie_data.load_data(TestHelper::TEST_U_DATA_FILE_PATH))
		assert_equal(33, movie_data.all_users.length)
		assert_equal(6, movie_data.all_movies.length)
	end

	def test_read_real_data_full
		movie_data = MovieData.new(TestHelper::DATA_DIR_PATH)
		assert_equal(100000, movie_data.load_data())
		assert_equal(943, movie_data.all_users.length)
		assert_equal(1682, movie_data.all_movies.length)
	end

	def test_read_real_data_base_test_pair
		movie_data = MovieData.new(TestHelper::DATA_DIR_PATH, :u1)
		assert_equal(80000, movie_data.load_data())
	end

	def test_rating
		movie_data = MovieData.new
		movie_data.load_data(TestHelper::TEST_U_DATA_FILE_PATH)

		assert_equal(1, movie_data.rating(1, 1))
		assert_equal(5, movie_data.rating(3, 2))
		assert_equal(3, movie_data.rating(33, 6))

		assert_equal(0, movie_data.rating(3, 7))
	end

	def test_predict
		movie_data = MovieData.new
		movie_data.load_data(TestHelper::TEST_U_DATA_FILE_PATH)

		assert_equal(5, movie_data.predict(3, 2), "must return stored rating exactly")

		# no user has similarity >= 0.86 to user 2
		assert_equal(3, movie_data.predict(2, 5), "must return uncertain prediction 3")

		# there are 11 users with similarity >= 0.79 to user 2, all of them rated movie 3
		# with "1" while user 2 has not rated movie 2 at all
		assert_in_delta(1.0, movie_data.predict(2, 3, 0.79), 0.0001)
	end

	def test_movies
		d = MovieData.new
		d.load_data(TestHelper::TEST_U_DATA_FILE_PATH)

		m1, m2, m3 = d.movie(1), d.movie(2), d.movie(3)

		assert_equal([m1, m2], d.movies(2))
		assert_equal([m1, m2, m3], d.movies(4))
	end

	def test_viewers
		d = MovieData.new
		d.load_data(TestHelper::TEST_U_DATA_FILE_PATH)

		# should be all users from 1 to 30
		m2viewers = d.viewers(2)
		assert_equal(30, m2viewers.size)
		(1..30).each {|i| assert_equal(i, m2viewers[i-1].id)}

		# should be all users from 31 to 33
		m4viewers = d.viewers(4)
		expected = [31, 32, 33]
		assert_equal(3, m4viewers.size)
		(0..2).each {|i| assert_equal(expected[i], m4viewers[i].id)}
	end

	def test_run_test
		movie_data = MovieData.new(TestHelper::DATA_DIR_PATH, :u1)
		movie_data.load_data()
		test = movie_data.run_test(15)

		assert_equal(15, test.results.length)
		
		rating2 = test.results[1]
		assert_equal(1, rating2.user.id)
		assert_equal(10, rating2.movie.id)
		assert_equal(3, rating2.rating)
	end
end