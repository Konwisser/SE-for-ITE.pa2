# This helper class is used to calculate popularities of films. The popularity of
# a movie depends on the number of users who have seen (or in our case: rated)
# this movie and also on the time at which the movie was seen most.
#
# Each rating of a movie adds to the movie's popularity but more recent ratings
# add exponentially more. A today's rating would add the maximum, which is +1.0+.
# A rating which is #popul_half_life_years# old would add half of it, means
# +0.5+. With +t+ as time in years since the rating was recorded, the popularity
# addition +P+ of this rating is
# +P(t) = 1 * (0.5 ^ (1/popul_half_life_years)) ^ t+.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class PopularityCalculator
	SECONDS_IN_YEAR = 3600.0 * 24.0 * 365.25
	# Creates a new PopularityCalculator object
	# time_class::
	#	the time class to be used for popularity calculations; per default set to
	#	Time; should be changed in unit tests in order to be independent from today's
	#	date
	# popul_half_life_years::
	# 	Defines the exponential popularity decrease of a movie over time. More
	# 	concrete it defines the movie's popularity half life in years. E.g. a value
	#	of +3+ would mean that a movie, having the popularity +1+ today, has the
	# 	popularity +1/2+ after 3 years, +1/4+ after 6 years, +1/8+ after 9 years
	# 	etc.; The default value is +3.0+.
	def initialize(time_class = Time, popul_half_life_years = 3.0)
		@time_class = time_class
		@popul_half_life_years = popul_half_life_years
		@popul_exp_base = 0.5 ** (1.0 / popul_half_life_years)
	end

	# Inserts the respective popularity into each provided movie and returns the list
	# sorted descended by popularity.
	# movies:: a list of Movie objects in which the respective popularity should be
	# inserted
	# returns:: the provided list of movies, sorted descended by popularity
	def insert_popularities(movies)
		movies.each do |m|
			m.ratings.each {|r| m.popularity += calc_popularity_addition(r)}
		end

		movies.sort {|a, b| b.popularity <=> a.popularity}
	end

	private

	# A today's rating would add the maximum to the film's popularity, which is 1.
	# A rating which is POPUL_HALF_LIFE_YEARS old would add half of it, means 0.5.
	# With t as time in years, the popularity addition P is
	# P(t) = 1 * POPUL_EXP_BASE ^ t
	def calc_popularity_addition(rating_obj)
		now_seconds = @time_class.now.to_i
		rating_seconds = rating_obj.timestamp.to_i
		diff_years = (now_seconds - rating_seconds) / SECONDS_IN_YEAR
		@popul_exp_base ** diff_years
	end
end