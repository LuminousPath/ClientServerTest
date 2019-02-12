require 'net/http'
require 'json'

class Network

	def self.addscore(name, completiontime)
		@uri = URI(GlobalConfig.config.url)
		@req = Net::HTTP::Post.new(@uri, 'Content-Type' => 'application/json')
		@req.body = {
			name: name,
			completiontime: completiontime
		}.to_json

		res = Net::HTTP.start(@uri.hostname, @uri.port) do |http|
			http.request(@req)
		end

		if res.code == "302"
			return true
		else
			return false
		end
	end
end