class Score
	attr_accessor :sprite, :score


	def initialize(scorespritesheet, scoreconfigfile)
		@sprite = Text.new(
		  '0',
		  x: 10, y: 10,
		  size: 30,
		  color: 'white',
		  z: 3
		)
		@score = 9999
	end

	def updatescore(subbingscore)
		if(@score > 0)
			@score -= subbingscore
		end
		@sprite.text = @score.to_s
	end

end