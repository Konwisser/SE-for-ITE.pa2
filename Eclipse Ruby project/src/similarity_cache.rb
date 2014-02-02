# Author: Georg Konwisser
# Email: software@konwisser.de

class SimilarityCache
	def initialize
		@sim = Hash.new {|hash, key| hash[key] = {}}
		@most_sim = {}
	end

	def get_sim(user1, user2)
		user1.id < user2.id ? @sim[user1][user2] : @sim[user2][user1]
	end
	
	# returns the provided similarity
	def put_sim(user1, user2, sim)
		user1, user2 = user2, user1 if user1.id > user2.id
		@sim[user1][user2] = sim
	end

	def get_most_sim(user)
		@most_sim[user]
	end

	# returns the provided most_sim_users list
	def put_most_sim(user, most_sim_users)
		@most_sim[user] = most_sim_users
	end
end