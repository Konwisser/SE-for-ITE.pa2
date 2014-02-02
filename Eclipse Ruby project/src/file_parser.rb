# Author: Georg Konwisser
# Email: software@konwisser.de

require_relative 'model/user'
require_relative 'model/movie'
require_relative 'model/rating'
require_relative 'rating_factory'

class FileParser

	attr_reader :id_to_user, :id_to_movie, :ratings
	def parse(file_path, first_k = nil)
		@id_to_user = Hash.new {|hash, key| hash[key] = User.new(key)}
		@id_to_movie = Hash.new {|hash, key| hash[key] = Movie.new(key)}
		@ratings = []
		@rf = RatingFactory.new

		lines = get_lines(file_path, first_k)
		lines.each {|line| parse_line(line)}
		lines.length
	end

	private

	def get_lines(file_path, first_k)
		return File.readlines(file_path) if first_k.nil?

		lines = []
		File.open(file_path, "r") do |file|
			while lines.length < first_k && line = file.gets
				lines << line
			end
		end
		lines
	end

	def parse_line(line)
		user_id_str, movie_id_str, rating_str, timestamp_str = line.split("\t")

		user_obj = @id_to_user[user_id_str.to_i]
		movie_obj = @id_to_movie[movie_id_str.to_i]

		@ratings << @rf.create(user_obj, movie_obj, rating_str.to_i, timestamp_str.to_i)
	end
end