class Configuration
	attr_accessor :frametime, :loop

	def initialize
		@frametime = nil
		@loop = nil
	end
end

class GlobalConfig
	class << self
		def config
			@config ||= Configuration.new
		end
	end
end