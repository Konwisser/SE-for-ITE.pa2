require_relative 'movie_data'
require "test/unit"

# class PopularityTester

# 	SECONDS_IN_YEAR = 3600.0 * 24.0 * 365.25

# 	def run_test_dummy_popularity
# 		puts "", "-------------------------------"
# 		puts "run_test_dummy_popularity"
# 		puts "-------------------------------", ""

# 		test_dummy_popularity(1, 0)
# 		test_dummy_popularity(2, 1)
# 		test_dummy_popularity(3, 4)
# 		test_dummy_popularity(4, 5)
# 		test_dummy_popularity(5, 6)
# 		test_dummy_popularity(6, 10)
# 		test_dummy_popularity(7, 100)
# 	end

# 	def run_test_read_popularity
# 		puts "", "-------------------------------"
# 		puts "run_test_read_popularity"
# 		puts "-------------------------------", ""

# 		movie_data = MovieData.new
# 		movie_data.load_data

# 		test_read_popularity(movie_data, 242)
# 		test_read_popularity(movie_data, 302)
# 		test_read_popularity(movie_data, 377)
# 		test_read_popularity(movie_data, 51)
# 		test_read_popularity(movie_data, 346)
# 		test_read_popularity(movie_data, 474)
# 		test_read_popularity(movie_data, 265)
# 		test_read_popularity(movie_data, 465)
# 		test_read_popularity(movie_data, 451)
# 		test_read_popularity(movie_data, 86)
# 	end

# 	def run_all
# 		#run_test_dummy_popularity
# 		#run_test_read_popularity
# 		print_popularity_list
# 	end

# 	private

# 		def test_dummy_popularity(movie_id, before_years)
# 			timestamp_num = Time.now.to_i - (before_years * SECONDS_IN_YEAR)
# 			rating_obj = Rating.new(nil, nil, 0, timestamp_num)
# 			movie_obj = Movie.new(movie_id)
# 			movie_obj.add_rating(rating_obj)

# 			puts "movie_id = #{movie_obj.id}"
# 			puts "before_years = #{before_years}, timestamp = #{rating_obj.timestamp}"
# 			puts "popularity = #{movie_obj.popularity}", ""
# 		end

# 		def test_read_popularity(movie_data, movie_id)
# 			puts movie_data.movie(movie_id).to_string
# 			puts "popularity = #{movie_data.popularity(movie_id)}", ""
# 		end
# end

class TestTime < Time
	
	def initialize(now_time)
		@now_time = now_time
	end

	def now
		@now_time
	end
end

class TestMovieData < Test::Unit::TestCase
	
	U_DATA_FILE_PATH = "ml-100k/u.data"
	U_TEST_DATA_FILE_PATH = "u_test.data"


	def print_header(header)
		puts "", ""
		puts "----------------------------------------------"
		puts header
		puts "----------------------------------------------"
		puts ""
	end

	def test_read_test_data
		movie_data = MovieData.new
		assert_equal(87, movie_data.load_data(U_TEST_DATA_FILE_PATH))
		assert_equal(30, movie_data.all_users.length)
		assert_equal(3, movie_data.all_movies.length)
	end

	def print_list_to_string(list, from_index, to_index)
		puts ""
		from_index.upto(to_index) {|index| puts "#{index + 1}.: #{list[index].to_string}"}
		puts ""
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