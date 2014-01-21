require_relative 'movie_data'

class PopularityTester

	#MovieData.new.load_data
	SECONDS_IN_YEAR = 3600.0 * 24.0 * 365.25

	def run_test_dummy_popularity
		puts "", "-------------------------------"
		puts "run_test_dummy_popularity"
		puts "-------------------------------", ""

		test_dummy_popularity(1, 0)
		test_dummy_popularity(2, 1)
		test_dummy_popularity(3, 4)
		test_dummy_popularity(4, 5)
		test_dummy_popularity(5, 6)
		test_dummy_popularity(6, 10)
		test_dummy_popularity(7, 100)
	end

	def run_test_read_popularity
		puts "", "-------------------------------"
		puts "run_test_read_popularity"
		puts "-------------------------------", ""

		movie_data = MovieData.new
		movie_data.load_data

		test_read_popularity(movie_data, 242)
		test_read_popularity(movie_data, 302)
		test_read_popularity(movie_data, 377)
		test_read_popularity(movie_data, 51)
		test_read_popularity(movie_data, 346)
		test_read_popularity(movie_data, 474)
		test_read_popularity(movie_data, 265)
		test_read_popularity(movie_data, 465)
		test_read_popularity(movie_data, 451)
		test_read_popularity(movie_data, 86)
	end

	def print_popularity_list
		puts "", "-------------------------------"
		puts "print_popularity_list"
		puts "-------------------------------", ""

		movie_data = MovieData.new
		movie_data.load_data

		list = movie_data.popularity_list
		0.upto(9) {|index| puts "#{index + 1}.: #{list[index].to_string}"}
		puts "..."
		
		fromIndex, toIndex = list.length - 10, list.length - 1
		fromIndex.upto(toIndex) {|index| puts "#{index + 1}.: #{list[index].to_string}"}
	end

	def run_all
		#run_test_dummy_popularity
		#run_test_read_popularity
		print_popularity_list
	end

	private

		def test_dummy_popularity(movie_id, before_years)
			timestamp_num = Time.now.to_i - (before_years * SECONDS_IN_YEAR)
			rating_obj = Rating.new(nil, nil, 0, timestamp_num)
			movie_obj = Movie.new(movie_id)
			movie_obj.add_rating(rating_obj)

			puts "movie_id = #{movie_obj.id}"
			puts "before_years = #{before_years}, timestamp = #{rating_obj.timestamp}"
			puts "popularity = #{movie_obj.popularity}", ""
		end

		def test_read_popularity(movie_data, movie_id)
			puts movie_data.movie(movie_id).to_string
			puts "popularity = #{movie_data.popularity(movie_id)}", ""
		end
end

PopularityTester.new.run_all