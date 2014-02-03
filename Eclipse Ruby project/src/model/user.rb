# This model class represents a single user and contains references to all movies
# rated by this user.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class User
	# the user's numeric id as provided in the data set
	attr_reader :id
	# Creates a new User object.
	# user_id:: the user's numeric id as provided in the data set
	def initialize(user_id)
		@id = user_id
		@movie_to_rating_num = {}
	end

	# Adds a reference to a rating in which this user rated a movie.
	# rating_obj:: Rating with a reference to this user
	# returns:: the numeric rating value contained in rating_obj
	def add_rating(rating_obj)
		@movie_to_rating_num[rating_obj.movie_obj] = rating_obj.rating_num
	end

	# Returns this user's rating for a given movie.
	# movie_obj:: Movie of interest
	# returns::
	#	the numeric rating value or +nil+ if no rating of this movie is stored with
	#	this user
	def rating_num(movie_obj)
		@movie_to_rating_num[movie_obj]
	end

	# Returns a list of all movies rated by this user.
	# returns:: a list of Movie objects
	def rated_movies
		@movie_to_rating_num.keys
	end

	# Defines equality by equal id (and type).
	# other:: the other object to be compared with
	def ==(other)
		other.class == self.class && other.id == @id
	end

	# Defines the string representation as
	# "User(id: _a_, ratings: _b_)"
	def to_s
		"User(id: #{@id}, ratings: #{@movie_to_rating_num.keys.length})"
	end
end