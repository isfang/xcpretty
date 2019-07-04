module Tuya
	require 'singleton'
	class Divertor
		include Singleton

		attr_accessor :build_errors, :build_symbols, :build_warnings
		def initialize
			@build_warnings = Hash.new
			@build_errors = Hash.new
			@build_symbols = Hash.new
		end

		def output

			puts @build_warnings.keys
			puts @build_errors.keys
			puts @build_symbols.keys
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