# This model class represents a single movie and contains references to all its
# ratings.
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class Movie
	# the numeric id of this movie as provided in the data set
	attr_reader :id

	# a list of ratings ( Rating objects ) for this movie
	attr_reader :ratings

	# A numeric value representing the popularity of this movie.
	# A higher value means a greater popularity.
	attr_accessor :popularity
	
	# Created a new Movie object.
	# movie_id:: the movie's numeric id as provided in the data set
	def initialize(movie_id)
		@id = movie_id
		@ratings = []
		@popularity = 0
	end

	# Adds a rating of this movie.
	# rating_obj:: Rating objects with a reference to this movie
	def add_rating(rating_obj)
		@ratings << rating_obj
	end

	# Defines equality by equal id (and type).
	# other:: the other object to be compared with
	def ==(other)
		other.class == self.class && other.id == @id
	end

	# Defines the string representation as
	# "Movie(id: _a_, ratings: _b_, popularity: _c_)"
	def to_s
		"Movie(id: #{@id}, ratings: #{@ratings.length}, popularity: #{@popularity})"
	end
end