# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative 'model/user'
require_relative 'model/movie'
require_relative 'model/rating'

class FileParser

	attr_reader :id_to_user, :id_to_movie

	def parse(file_path)
		@id_to_user = Hash.new {|hash, key| hash[key] = User.new(key)}
		@id_to_movie = Hash.new {|hash, key| hash[key] = Movie.new(key)}

		lines = File.readlines(file_path)
		lines.each {|line| read_line(line)}
		lines.length
	end

	private

		def read_line(line)
			user_id_str, movie_id_str, rating_str, timestamp_str = line.split("\t")
			
			user_obj = @id_to_user[user_id_str.to_i]
			movie_obj = @id_to_movie[movie_id_str.to_i]

			rating_obj = Rating.new(user_obj, movie_obj, rating_str.to_i, timestamp_str.to_i)
			user_obj.add_rating(rating_obj)			
			movie_obj.add_rating(rating_obj)
		end
end