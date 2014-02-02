# Author: Georg Konwisser
# Email: software@konwisser.de

#compat mixin for Ruby 1.9.1 with test-unit gem in Eclipse (workaround for
# missing variable initialization in eclipse thankfully taken from
# https://bugs.eclipse.org/bugs/show_bug.cgi?id=323736)
module Test
	module Unit
		module UI
			SILENT = false
		end

		class AutoRunner
			def output_level=(level)
				self.runner_options[:output_level] = level
			end
		end
	end
end
