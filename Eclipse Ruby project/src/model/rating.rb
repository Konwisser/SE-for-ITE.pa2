# This model class represents a single user's rating of a single movie.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class Rating
	# the rating User
	attr_reader :user_obj

	# the rated Movie
	attr_reader :movie_obj

	# the numeric rating of the referenced user for the referenced movie
	attr_reader :rating_num

	# a Time object representing the time the rating took place
	attr_reader :timestamp
	# Creates a Rating object.
	# user_obj:: the rating User
	# movie_obj:: the rated Movie
	# rating_num:: the numeric rating between 1 and 5
	# timestamp_num::
	#	an integer representing the time the rating took place (in seconds since the
	# 	Epoch)
	def initialize(user_obj, movie_obj, rating_num, timestamp_num)
		@user_obj, @movie_obj, @rating_num = user_obj, movie_obj, rating_num
		@timestamp = Time.at(timestamp_num)
	end
end