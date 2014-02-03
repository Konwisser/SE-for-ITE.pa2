require_relative 'model/user'
require_relative 'model/movie'
require_relative 'model/rating'

# This factory class has only one purpose: it creates Rating objects. The reason
# why this class should be used instead of the usual class initialization are the
# bidirectional references between a Rating object and its contained objects.
# This factory makes sure that all these references are set properly.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class RatingFactory

	# Creates a Rating object and makes sure that all references between the provided
	# and created objects are set properly.
	# user:: the User object which represents the user who gave the rating
	# movie:: the Movie object which represents the rated movie
	# rating_num::
	#	an integer value between 1 and 5 which represents the user's rating for the
	#	given movie
	# timestamp::
	#	a Time object which represents the time at which this rating was done
	def create(user, movie, rating_num, timestamp)
		rating = Rating.new(user, movie, rating_num, timestamp)

		user.add_rating(rating)
		movie.add_rating(rating)

		rating
	end
end