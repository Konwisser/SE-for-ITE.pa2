require_relative 'eclipse_test_case_workaround.rb'

require_relative '../similarity_cache'
require_relative '../model/user'

# Author:: Georg Konwisser (mailto:software@konwisser.de)
class SimilarityCacheTest < Test::Unit::TestCase
	def test_get_sim
		cache = SimilarityCache.new()

		u1, u2 = User.new(1), User.new(2)

		# intentionally two times for testing the effect of not finding an entry
		assert_nil(cache.get_sim(u1,u2))
		assert_nil(cache.get_sim(u1,u2))

		# test reverse retrieval
		cache.put_sim(u1, u2, 0.6)
		assert_equal(0.6, cache.get_sim(u2,u1))

		# test reverse storage
		u3, u4 = User.new(3), User.new(4)
		cache.put_sim(u4, u3, 0.7)
		assert_equal(0.7, cache.get_sim(u3, u4))
	end

end