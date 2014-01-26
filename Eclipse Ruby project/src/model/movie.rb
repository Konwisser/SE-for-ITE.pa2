# Author: Georg Konwisser
# Email: software@konwisser.de

class Movie
	attr_reader :id, :ratings
	attr_accessor :popularity

	def initialize(movie_id)
		@id = movie_id
		@ratings = []
		@popularity = 0
	end

	def add_rating(rating_obj)
		@ratings << rating_obj
	end

	def to_string
		"Movie(id: #{@id}, ratings_count: #{@ratings.length}, popularity: #{@popularity})"
	end
end