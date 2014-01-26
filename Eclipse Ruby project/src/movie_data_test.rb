# Author: Georg Konwisser
# Email: software@konwisser.de

require "test/unit"

require_relative 'movie_data'

class TestTime < Time
	def initialize(now_time)
		@now_time = now_time
	end

	def now
		@now_time
	end
end

class TestMovieData < Test::Unit::TestCase

	U_DATA_FILE_PATH = "data/ml-100k/u.data"
	U_TEST_DATA_FILE_PATH = "data/u_test.data"
	def print_header(header)
		puts "", ""
		puts "----------------------------------------------"
		puts header
		puts "----------------------------------------------"
		puts ""
	end

	def print_list_to_string(list, from_index, to_index)
		puts ""
		from_index.upto(to_index) {|index| puts "#{index + 1}.: #{list[index].to_string}"}
		puts ""
	end

	def test_read_test_data
		movie_data = MovieData.new
		assert_equal(97, movie_data.load_data(U_TEST_DATA_FILE_PATH))
		assert_equal(33, movie_data.all_users.length)
		assert_equal(6, movie_data.all_movies.length)
	end

	def test_popularity_calculation
		pop_half_life_years = 3.0

		# set current time to 2014-01-01 00:00
		test_time = TestTime.new(Time.new(2014))
		movie_data = MovieData.new(test_time, pop_half_life_years)
		movie_data.load_data(U_TEST_DATA_FILE_PATH)

		pop_base = 0.5 ** (1.0 / pop_half_life_years)
		popularities = [1.0, 2.0, 3.0].map {|years| (pop_base ** years) * 3.0}

		movies = [4, 5, 6].map {|movie_id| movie_data.movie(movie_id)}
		[0, 1, 2].each {|i| assert_in_delta(popularities[i], movies[i].popularity, 0.001)}
	end

	def test_print_real_popularity_list
		print_header("test_print_real_popularity_list")

		movie_data = MovieData.new
		movie_data.load_data(U_DATA_FILE_PATH)

		list = movie_data.popularity_list
		print_list_to_string(list, 0, 9)
		puts "..."
		print_list_to_string(list, list.length - 10, list.length - 1)
	end

	def test_user_to_user_similarity
		movie_data = MovieData.new
		movie_data.load_data(U_TEST_DATA_FILE_PATH)

		max_user_distance = ((4 ** 2) * movie_data.all_movies.length) ** 0.5

		assert_equal(movie_data.similarity(1, 2), movie_data.similarity(2, 1))
		assert_in_delta(1.0 - 2.0 / max_user_distance, movie_data.similarity(1, 2), 0.0001)
	end

	def test_most_similar_on_test_data
		movie_data = MovieData.new
		movie_data.load_data(U_TEST_DATA_FILE_PATH)

		list = movie_data.most_similar(1, 10)
		assert_equal(10, list.length, "list should contain exactly 10 most similar users")

		list.each do |user_obj|
			assert(user_obj.id > 10, "user_id #{user_obj.id} is < 11, shouldn't be in list")
			assert(user_obj.id < 21, "user_id #{user_obj.id} is > 20, shouldn't be in list")
		end
	end

	def test_most_similar_on_real_data
		print_header("test_most_similar_on_real_data")

		movie_data = MovieData.new
		movie_data.load_data(U_DATA_FILE_PATH)

		puts "the most similar users to #{movie_data.user(1).to_string} are:"

		list = movie_data.most_similar(1)
		print_list_to_string(list, 0, list.length - 1)
	end
end