# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative '../movie_data'
require_relative '../movie_test'
require_relative '../rating_factory'

require_relative '../model/user'
require_relative '../model/movie'

require_relative 'eclipse_test_case_workaround'

class MovieTestTest < Test::Unit::TestCase
	def test_mean
		test = MovieTest.new
		rf = RatingFactory.new

		u1, m1 = User.new(1), Movie.new(1)
		test.add_result(rf.create(u1, m1, 3, 0), 2)
		test.add_result(rf.create(u1, m1, 2, 0), 4)

		assert_equal(1.5, test.mean())
	end

	def test_stddev
		test = MovieTest.new
		rf = RatingFactory.new

		u1, m1 = User.new(1), Movie.new(1)
		test.add_result(rf.create(u1, m1, 3, 0), 2) # error: 1
		test.add_result(rf.create(u1, m1, 2, 0), 4) # error: 2
		test.add_result(rf.create(u1, m1, 4, 0), 1) # error: 3

		# mean = (1+2+3)/3 = 2
		# stddev = (((1-2)^2 + (2-2)^2 + (3-2)^2) / 3) ^ 1/2 = 2/3 ^ 1/2 = 0.81649658
		
		assert_in_delta(0.81649658, test.stddev(), 0.00000001)
	end
	
	def test_rms
		test = MovieTest.new
		rf = RatingFactory.new

		u1, m1 = User.new(1), Movie.new(1)
		test.add_result(rf.create(u1, m1, 3, 0), 2) # error: 1
		test.add_result(rf.create(u1, m1, 2, 0), 4) # error: 2
		test.add_result(rf.create(u1, m1, 4, 0), 1) # error: 3

		# rms = ((1^2 + 2^2 + 3^2) / 3) ^ 1/2 = 14/3 ^ 1/2 = 2.16024690
		
		assert_in_delta(2.16024690, test.rms(), 0.00000001)
	end	
	
	def test_to_a
		test = MovieTest.new
		rf = RatingFactory.new

		u1, m1 = User.new(1), Movie.new(1)
		test.add_result(rf.create(u1, m1, 3, 0), 2)
		test.add_result(rf.create(u1, m1, 2, 0), 4)
		test.add_result(rf.create(u1, m1, 4, 0), 1)
		
		exp_array = [1, 1, 3, 2, 1, 1, 2, 4, 1, 1, 4, 1]
		assert_equal(exp_array, test.to_a())
	end
end