# This utility class is used to calculate rating predictions based on a known
# data set of ratings.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class RatingPredicter

	# Creates a new RatingPredicter object.
	# similarity_calculator::
	#	the SimilarityCalculator to be used for prediction calculations.
	def initialize(similarity_calculator)
		@sim_calc = similarity_calculator
	end

	# Calculates the rating prediction of the given user for the given movie.
	# user_obj:: a User object representing the user of interest
	# movie_obj:: a Movie object representing the movie of interest
	def predict(user_obj, movie_obj)
		stored_rating = user_obj.rating_num(movie_obj)
		return stored_rating if !stored_rating.nil?

		rating_sum, user_count = 0.0, 0
		@sim_calc.most_similar(user_obj.id).each do |u|
			if !u.rating_num(movie_obj).nil?
				rating_sum += u.rating_num(movie_obj)
				user_count += 1
			end
		end

		return 3 if user_count == 0
		return rating_sum / user_count
	end
end