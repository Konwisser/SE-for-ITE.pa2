# Author: Georg Konwisser
# Email: software@konwisser.de

class User
	attr_reader :id

	def initialize(user_id)
		@id = user_id
		@movie_to_rating_num = {}
	end

	def add_rating(rating_obj)
		@movie_to_rating_num[rating_obj.movie_obj] = rating_obj.rating_num
	end

	def rating_num(movie_obj)
		@movie_to_rating_num[movie_obj]
	end

	def rated_movies
		@movie_to_rating_num.keys
	end

	def ==(other)
		other.class == self.class && other.id == @id
	end
	
	def to_s
		"User(id: #{@id}, ratings: #{@movie_to_rating_num.keys.length})"
	end
end