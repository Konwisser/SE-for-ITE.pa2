# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative 'model/user'
require_relative 'model/movie'
require_relative 'model/rating'

class RatingFactory
	def create(user, movie, rating_num, timestamp)
		rating = Rating.new(user, movie, rating_num, timestamp)
		
		user.add_rating(rating)
		movie.add_rating(rating)
		
		rating
	end
end