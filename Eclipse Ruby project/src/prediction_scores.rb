# Author:: Georg Konwisser (mailto:software@konwisser.de)

require_relative 'movie_data'

data = MovieData.new('data/ml-100k', :u1)
data.load_data()
test = data.run_test(20000)
#puts test.to_a()
puts "mean: #{test.mean()}, stddev: #{test.stddev()}"