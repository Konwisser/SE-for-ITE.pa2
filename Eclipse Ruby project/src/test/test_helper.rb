# Author: Georg Konwisser
# Email: software@konwisser.de

class TestHelper
	
	DATA_DIR_PATH = "data/ml-100k"
	U_DATA_FILE_PATH = "#{DATA_DIR_PATH}/u.data"
	TEST_U_DATA_FILE_PATH = "data/u_test.data"
	
	def print_header(header)
		puts "", ""
		puts "----------------------------------------------"
		puts header
		puts "----------------------------------------------"
		puts ""
	end

	def print_list_to_string(list, from_index, to_index)
		puts ""
		from_index.upto(to_index) {|index| puts "#{index + 1}.: #{list[index]}"}
		puts ""
	end
end