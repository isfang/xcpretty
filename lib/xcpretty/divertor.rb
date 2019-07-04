module Tuya
	require 'singleton'
	require 'colored'
	class Divertor
		include Singleton

		attr_accessor :is_build_success
		attr_accessor :build_errors, :build_symbols, :build_warnings
		def initialize
			@build_warnings = Hash.new
			@build_errors = Hash.new
			@build_symbols = Hash.new
			@is_build_success = false
		end

		def output
			if @is_build_success
				puts "Build Succeeded".green
			else
				output_build '(～o￣3￣)～ build errors has found:', @build_errors
				output_build '(～o￣3￣)～ build symbols has found:', @build_symbols
			end
			# output_build 'build warnings maybe', @build_warnings
		end

		def output_build(pre, build)
			puts "#{pre}".red
			build.each do |k, v|
				# puts "#{v.items.uniq.size} errors in 「#{k}」".magenta.underline
				puts "#{v.items.uniq.size} errors in 「#{k}」".cyan
				puts v.items.uniq
			end
		end

		def divert_build_success
			@is_build_success = true
		end

		def divert_warnings(method, content)
			divert method, content, @build_warnings
		end

		def divert_errors(method, content)
			divert method, content, @build_errors
		end

		def divert_symbols(method, content)
			divert method, content, @build_symbols
		end

		def divert(method, content, build)
			build[method] = DivertorContent.new unless build[method]

			divert_content = build[method]
			divert_content.content_type = method
			divert_content.items.push content
		end
	end

	class DivertorContent
		attr_accessor :content_type, :items
		def initialize
			@content_type = ''
			@items = []
		end
	end
end