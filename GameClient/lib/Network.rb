require 'net/http'
require 'json'

class Network

	@uri = URI('http://0.0.0.0:3000/scores')
	@req = Net::HTTP::Post.new(@uri, 'Content-Type' => 'application/json')

	def self.addscore(name, completiontime)
		@req.body = {
			name: name,
			completiontime: completiontime
		}.to_json

		res = Net::HTTP.start(@uri.hostname, @uri.port) do |http|
			http.request(@req)
		end
	end
end