module Tuya
	require 'singleton'
	require 'colored'
	class Divertor
		include Singleton

		attr_accessor :is_build_success
		attr_accessor :build_errors, :build_symbols, :build_warnings
		attr_accessor :format_build_errors, :format_undefined_symbols, :format_duplicate_symbols, :format_build_warnings
		def initialize
			@build_warnings = Hash.new
			@build_errors = Hash.new
			@build_symbols = Hash.new

			@format_build_warnings = Hash.new
			@format_build_errors = Hash.new
			@format_undefined_symbols = Hash.new
			@format_duplicate_symbols = Hash.new

			@is_build_success = false
		end

		def output

			puts "start diverting output ... #{@is_build_success}"

			if @is_build_success
				# puts "qwwwwwww"
				puts " 😏 Build Succeeded".green
			else
				# puts "qwww"

				# puts @format_build_errors
				# puts @format_duplicate_symbols
				# puts @format_undefined_symbols
				#
				# puts @build_errors
				# puts @build_symbols
				# puts @build_warnings.keys.size

				output_format_build '😭 build errors :', @format_build_errors
				output_format_build_duplicate_symbols'😭 build duplicate symbols :', @format_duplicate_symbols
				output_format_build_undefined_symbols'😭 build undefined symbols :', @format_undefined_symbols

				output_build '😭 build errors :', @build_errors
				output_build'😭 build symbols :', @build_symbols
				# output_build'😭 build undefined symbols :', @forundefined_symbols
			end
		end

		def divert_build_success
			# puts "divert_build_success"
			@is_build_success = true
		end

		def divert_warnings(method, content)
			# puts "divert_warnings"
			divert method, content, @build_warnings
		end

		def divert_errors(method, content)
			# puts "divert_errors"
			divert method, content, @build_errors
		end

		def divert_symbols(method, content)
			# puts "divert_symbols"
			divert method, content, @build_symbols
		end


		def divert_format_warnings(method, content)
			# puts "divert_format_warnings"
			format_divert method, content, @format_build_warnings
		end

		def divert_format_errors(method, content)
			# puts "divert_format_errors"
			format_divert method, content, @format_build_errors
		end

		def divert_duplicate_symbols(method, content)
			# puts "divert_duplicate_symbols"
			format_divert_duplicate_symbols method, content, @format_duplicate_symbols
		end


		def divert_undefined_symbols(method, content)
			# puts "divert_undefined_symbols"
			format_divert_undefined_symbols method, content, @format_undefined_symbols
		end

		private

		def divert(method, content, build)
			build[method] = DivertorContent.new unless build[method]

			divert_content = build[method]
			divert_content.content_type = method
			divert_content.items.push content
		end

		def format_divert(method, content, build)
			build[method] = DivertorFormatContent.new unless build[method]

			divert_content = build[method]
			divert_content.content_type = method
			divert_content.items[content[:reason]] = content
		end

		def format_divert_duplicate_symbols(method, content, build)
			divert method, content, build
		end

		def format_divert_undefined_symbols(method, content, build)
			divert method, content, build
		end

		def output_build(pre, build)
			puts "#{pre}".red if build.keys.size > 0
			build.each do |k, v|
				# puts "#{v.items.uniq.size} errors in 「#{k}」".magenta.underline
				puts "#{v.items.uniq.size} errors in 「#{k}」".cyan
				puts v.items.uniq
			end
		end

		def output_format_build(pre, build)
			puts "#{pre}".red if build.keys.size > 0
			build.each do |k, v|
				puts "#{v.items.keys.size} errors in 「#{k}」".cyan
				# puts v.items
				v.items.each do |sub_k, sub_v|
					puts "\nFile #{sub_v[:file_name]}"
					puts "#{sub_k}".red
				end
			end
		end

		def output_format_build_duplicate_symbols(pre, build)
			output_build pre, build
		end

		def output_format_build_undefined_symbols(pre, build)
			output_build pre, build
		end
	end

	class DivertorContent
		attr_accessor :content_type, :items
		def initialize
			@content_type = ''
			@items = []
		end
	end

	class DivertorFormatContent
		attr_accessor :content_type, :items
		def initialize
			@content_type = ''
			@items = Hash.new
		end
	end
end
