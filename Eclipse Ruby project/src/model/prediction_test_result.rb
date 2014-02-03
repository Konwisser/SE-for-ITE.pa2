# This model class is used to compare a provided rating with a predicted one.
# Therefore it contains the rating User, the rated Movie, the provided numeric
# rating and the predicted numeric rating.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class PredictionTestResult
	# numeric value representing the predicted rating for the user and movie in this
	# tuple
	attr_reader :pred_rating
	# Creates a new PredictionTestResult object.
	# rating_obj:: Rating object containing the actual rating
	# pred_rating:: predicted rating as numeric value between 1.0 and 5.0
	def initialize(rating_obj, pred_rating)
		@rating_obj = rating_obj
		@pred_rating = pred_rating
	end

	# the rating User in this prediction test
	def user
		@rating_obj.user_obj
	end

	# he rated Movie in this prediction test
	def movie
		@rating_obj.movie_obj
	end

	# the actual (not predicted) numeric rating of this prediction test (numeric
	# value between 1.0 and 5.0)
	def rating
		@rating_obj.rating_num
	end
end