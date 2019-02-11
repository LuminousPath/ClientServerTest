require 'ruby2d'
require 'xmlsimple'

class Character
	attr_reader :sprite
	attr_accessor :state

	def initialize(spritesheet, configloc)

		charconfig = CharacterConfig.new(configloc)

		@sprite = Sprite.new(
			spritesheet,
			time: GlobalConfig.config.frametime,
			loop: GlobalConfig.config.loop,
			z: 2,
			animations: charconfig.animationset
		)
		@sprite.play animation: :idle
		@sprite.x = 0
		@sprite.y = 0
	end

	def updateplayerstate(states = {})
		if states[:colliding] == true
			Input::INPUTSTATUS[:colliding] = true
		elsif states[:colliding] == false
			Input::INPUTSTATUS[:colliding] = false
		end
	end

	def runanimate(playerstate)
		if Input::INPUTSTATUS[:colliding]
			Input::INPUTSTATUS[:falling] = false
		elsif Input::INPUTSTATUS[:jumping] == false
			Input::INPUTSTATUS[:falling] = true
		end
		if Input::INPUTSTATUS[:falling]
			@sprite.y += 3
		end
		if Input::INPUTSTATUS[:movingright]
			@sprite.x += 1
		elsif Input::INPUTSTATUS[:movingleft]
			@sprite.x -= 1
		end
		if Input::INPUTSTATUS[:jumping]
			@sprite.y -= 3
		end
	end

end

class CharacterConfig
	attr_reader :animationconfig,  :animationset

	def initialize(configloc)
		@animationconfig = XmlSimple.xml_in(open(configloc))

		@animationset = animationconfig['Animation'].map.with_index do |animation|
			[
				animation['name'].to_sym,
				animation['SubTexture'].map.with_index do |frame|
					{
						:x => frame["x"].to_i,
						:y => frame["y"].to_i,
						:height => frame["height"].to_i,
						:width => frame["width"].to_i
					}
				end
			]
		end.to_h
	end
end