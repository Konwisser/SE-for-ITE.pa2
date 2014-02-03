
require "test/unit"

require_relative '../movie_data'
require_relative 'eclipse_test_case_workaround'
require_relative 'test_time'
require_relative 'test_helper'

# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MovieDataTestPopularity < Test::Unit::TestCase
	
	def test_popularity_calculation
		pop_half_life_years = 3.0

		movie_data = MovieData.new
		movie_data.popul_half_life_years = pop_half_life_years
		# for test reasons: fix current time to 2014-01-01 00:00
		movie_data.time_class = TestTime.new(Time.new(2014))
		movie_data.load_data(TestHelper::TEST_U_DATA_FILE_PATH)

		pop_base = 0.5 ** (1.0 / pop_half_life_years)
		popularities = [1.0, 2.0, 3.0].map {|years| (pop_base ** years) * pop_half_life_years}

		movies = [4, 5, 6].map {|movie_id| movie_data.movie(movie_id)}
		[0, 1, 2].each {|i| assert_in_delta(popularities[i], movies[i].popularity, 0.001)}
	end

	def test_print_real_popularity_list
		TestHelper.new.print_header("test_print_real_popularity_list")

		movie_data = MovieData.new
		movie_data.load_data(TestHelper::U_DATA_FILE_PATH)

		list = movie_data.popularity_list
		TestHelper.new.print_list_to_string(list, 0, 9)
		puts "..."
		TestHelper.new.print_list_to_string(list, list.length - 10, list.length - 1)
	end

end