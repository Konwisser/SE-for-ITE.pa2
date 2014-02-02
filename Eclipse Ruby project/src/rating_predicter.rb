# Author: Georg Konwisser
# Email: software@konwisser.de

class RatingPredicter
	def initialize(similarity_calculator)
		@sim_calc = similarity_calculator
	end

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

		puts "predicting rating for user=#{user_obj.id}, movie=#{movie_obj.id}: rating_sum=#{rating_sum}, user_count=#{user_count}, pred_rating=#{rating_sum/user_count}"

		return 3 if user_count == 0
		return rating_sum / user_count
	end
end