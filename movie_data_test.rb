require_relative 'movie_data'

class PopularityTester

	#MovieData.new.load_data
	SECONDS_IN_YEAR = 3600.0 * 24.0 * 365.25

	def test_popularity(movie_id, before_years)
		timestamp_num = Time.now.to_i - (before_years * SECONDS_IN_YEAR)
		rating_obj = Rating.new(nil, nil, 0, timestamp_num)
		movie_obj = Movie.new(movie_id)
		movie_obj.add_rating(rating_obj)

		puts "movie_id = #{movie_obj.id}"
		puts "before_years = #{before_years}, timestamp = #{rating_obj.timestamp}"
		puts "popularity = #{movie_obj.popularity}", ""
	end

	def run
		tester = PopularityTester.new
		tester.test_popularity(1, 0)
		tester.test_popularity(2, 1)
		tester.test_popularity(3, 4)
		tester.test_popularity(4, 5)
		tester.test_popularity(5, 6)
		tester.test_popularity(6, 10)
		tester.test_popularity(7, 100)
	end
end