# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative 'model/prediction_test_result'

class MovieTest
	attr_reader :results
	def initialize
		@results = []
	end

	def add_result(rating_obj, pred_rating)
		@results << PredictionTestResult.new(rating_obj, pred_rating)
	end

	def mean
		error_sum = @results.reduce(0.0) {|sum, r| sum + (r.rating - r.pred_rating).abs}
		error_sum / @results.length
	end

	def stddev
		cur_mean = mean()
		errors = @results.map {|r| (r.rating - r.pred_rating).abs}
		sq_dif_sum = errors.reduce(0.0) {|sum, e| sum + (e - cur_mean)**2}
		(sq_dif_sum / errors.length) ** 0.5
	end

	def rms
		errors = @results.map {|r| (r.rating - r.pred_rating).abs}
		sq_sum = errors.reduce(0.0) {|sum, e| sum + e **2}
		(sq_sum / errors.length) ** 0.5
	end

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