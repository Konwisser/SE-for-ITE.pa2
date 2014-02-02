# Author: Georg Konwisser
# Email: software@konwisser.de

class PredictionTestResult

	attr_reader :pred_rating
	def initialize(rating_obj, pred_rating)
		@rating_obj = rating_obj
		@pred_rating = pred_rating
	end

	def user
		@rating_obj.user_obj
	end

	def movie
		@rating_obj.movie_obj
	end

	def rating
		@rating_obj.rating_num
	end
end