# Author:: Georg Konwisser (mailto:software@konwisser.de)
class PopularityCalculator	
	SECONDS_IN_YEAR = 3600.0 * 24.0 * 365.25
	
	def initialize(clock = Time, popul_half_life_years = 3.0)
		@clock = clock
		@popul_half_life_years = popul_half_life_years
		@popul_exp_base = 0.5 ** (1.0 / popul_half_life_years)
	end

	# returns a list of the provided movies, sorted descended by popularity
	def insert_popularities(movies)
		movies.each do |m|
			m.ratings.each {|r| m.popularity += calc_popularity_addition(r)}
		end

		movies.sort {|a, b| b.popularity <=> a.popularity}
	end


	private
		# A today's rating would add the macimum to the film's popularity, which is 1.
		# A rating which is POPUL_HALF_LIFE_YEARS old would add half of it, means 0.5.
		# With t as time in years, the popularity addition P is
		# P(t) = 1 * POPUL_EXP_BASE ^ t
		def calc_popularity_addition(rating_obj)
			now_seconds = @clock.now.to_i
			rating_seconds = rating_obj.timestamp.to_i
			diff_years = (now_seconds - rating_seconds) / SECONDS_IN_YEAR
			@popul_exp_base ** diff_years
		end
end