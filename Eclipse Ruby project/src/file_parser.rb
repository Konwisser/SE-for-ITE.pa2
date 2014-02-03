# This utility class is used to read in and parse files of the rated movies data
# set.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class FileParser

	require_relative 'model/user'
	require_relative 'model/movie'
	require_relative 'model/rating'
	require_relative 'rating_factory'

	# a Hash of all parsed users
	# key:: the user's numeric id as provided in the data set
	# value:: the corresponding User object
	attr_reader :id_to_user

	# a Hash of all parsed movies
	# key:: the movie's numeric id as provided in the data set
	# value:: the corresponding Movie object
	attr_reader :id_to_movie

	# a list of all parsed ratings where each line in the data set is represented by
	# one Rating object
	attr_reader :ratings
	
	# Parses the given file and fills the collections id_to_user, id_to_movie, and
	# ratings with corresponding User, Movie, and Rating objects
	# file_path:: path to the file to be parsed
	# first_k::
	#	optional integer indicating how many lines of the file should be
	#	parsed - if omitted, the whole file will be parsed
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