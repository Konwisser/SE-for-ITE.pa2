class TestTime < Time
	def initialize(now_time)
		@now_time = now_time
	end

	def now
		@now_time
	end
end
