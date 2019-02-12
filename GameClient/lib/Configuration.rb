class Configuration
	attr_accessor :frametime, :loop, :height, :width, :title, :resizable, :background, :url

	def initialize
		@frametime = nil
		@loop = nil
		@height = nil
		@width = nil
		@title = nil
		@resizable = nil
		@background = nil
		@url = nil
	end
end

class GlobalConfig
	class << self
		def config
			@config ||= Configuration.new
		end
	end
end