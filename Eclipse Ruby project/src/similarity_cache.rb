# This class is used to cache already calculated similarities between two users
# as well as the "most similar users" lists for particular users.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class SimilarityCache

	# Creates a new SimilarityCache object.
	def initialize
		@sim = Hash.new {|hash, key| hash[key] = {}}
		@most_sim = {}
	end

	# Returns the similarity for the given two users if already stored or +nil+
	# otherwise. The order of users does not matter.
	# user1:: a User object representing one of the two users
	# user2:: a User object representing the other user
	# returns::
	#	a numeric value between 0.0 and 1.0 representing the similarity or +nil+ if
	#	no similarity has been stored for this pair of users
	def get_sim(user1, user2)
		user1.id < user2.id ? @sim[user1][user2] : @sim[user2][user1]
	end

	# Stores the similarity for the given two users. The order of users does not
	# matter.
	# user1:: a User object representing one of the two users
	# user2:: a User object representing the other user
	# sim::
	#	a numeric value between 0.0 and 1.0 representing the similarity for this pair
	#	of users
	# returns:: the provided similarity +sim+
	def put_sim(user1, user2, sim)
		user1, user2 = user2, user1 if user1.id > user2.id
		@sim[user1][user2] = sim
	end

	# Returns the list of most similar users to the given user if the list is already
	# stored or +nil+ otherwise.
	# user:: a User object representing the user of interest
	def get_most_sim(user)
		@most_sim[user]
	end

	# Stores the list of most similar users to the given user.
	# user:: a User object representing the user of interest
	# most_sim_users:: list of users most similar to +user+
	# returns:: the provided +most_sim_users+ list
	def put_most_sim(user, most_sim_users)
		@most_sim[user] = most_sim_users
	end

	# Clears all lists of most similar users. Useful if the threshold for "is among
	# the most similar users" has changed.
	def clear_most_sim
		@most_sim = {}
	end
end