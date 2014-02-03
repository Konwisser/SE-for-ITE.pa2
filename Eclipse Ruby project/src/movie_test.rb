require_relative 'model/prediction_test_result'

# This class contains all results of a rating prediction accuracy test and
# provides statistical methods such as mean error or error standard deviation.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MovieTest
	# a lits of PredictionTestResult objects each representing the real and the
	# calculated (predicted) rating for a given user-movie pair
	attr_reader :results
	# Creates a new MovieTest object.
	def initialize
		@results = []
	end

	# Adds a new rating prediction test result.
	# rating_obj::
	#	Rating object containing the real (ideal) rating of the contained user-movie
	#	pair
	# pred_rating:: the predicted rating to be compared against the real one
	def add_result(rating_obj, pred_rating)
		@results << PredictionTestResult.new(rating_obj, pred_rating)
	end

	# Calculates the mean error of all previously added prediction test results.
	def mean
		error_sum = @results.reduce(0.0) {|sum, r| sum + (r.rating - r.pred_rating).abs}
		error_sum / @results.length
	end

	# Calculates the error standard deviation of all previously added prediction test
	# results.
	def stddev
		cur_mean = mean()
		errors = @results.map {|r| (r.rating - r.pred_rating).abs}
		sq_dif_sum = errors.reduce(0.0) {|sum, e| sum + (e - cur_mean)**2}
		(sq_dif_sum / errors.length) ** 0.5
	end

	# Calculates the root mean square error of all previously added prediction test
	# results.
	def rms
		errors = @results.map {|r| (r.rating - r.pred_rating).abs}
		sq_sum = errors.reduce(0.0) {|sum, e| sum + e **2}
		(sq_sum / errors.length) ** 0.5
	end

	# Returns all previously added prediction test results as a list. The format of
	# the list is [user_id1, movie_id1, real_rating1, predicted_rating1, user_id2,
	# movie_id2, real_rating2, predicted_rating2, user_id3, ...]
	def to_a
		result = []
		@results.each do |r|
			result << r.user.id
			result << r.movie.id
			result << r.rating
			result << r.pred_rating
		end
		result
	end
end