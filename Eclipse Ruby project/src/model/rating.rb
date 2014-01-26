# Author: Georg Konwisser
# Email: software@konwisser.de

class Rating
	attr_reader :user_obj, :movie_obj, :rating_num, :timestamp

	def initialize(user_obj, movie_obj, rating_num, timestamp_num)
		@user_obj, @movie_obj, @rating_num = user_obj, movie_obj, rating_num
		@timestamp = Time.at(timestamp_num)
	end
end