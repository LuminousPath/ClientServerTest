require 'ruby2d'
require 'xmlsimple'

class Character
	attr_reader :sprite,
		:spriteleft,
		:spriteright,
		:spriteup,
		:spritedown,
		:spritenortheast,
		:spritenorthwest,
		:spritesouthwest,
		:spritesoutheast
	attr_accessor :state, :gameover

	def initialize(spritesheet, configloc)

		charconfig = CharacterConfig.new(configloc)

		#create player sprite
		@sprite = Sprite.new(
			spritesheet,
			time: GlobalConfig.config.frametime,
			loop: GlobalConfig.config.loop,
			z: 2,
			animations: charconfig.animationset
		)
		#set default animation
		@sprite.play animation: :idle
		#set the bounding elements for the sprite for faster collision
		#(eight spots are tested for containment of any collision boxes to determine collision direction)
		@spriteleft = {x: @sprite.x, y: (@sprite.y + (@sprite.clip_height/2))}
		@spriteright = {x: (@sprite.x + @sprite.clip_width), y: (@sprite.y + (@sprite.clip_height/2))}
		@spriteup = {x: (@sprite.x + (@sprite.clip_width/2)), y: @sprite.y}
		@spritedown = {x: (@sprite.x + (@sprite.clip_width/2)), y: (@sprite.y + @sprite.clip_height)}
		@spritenortheast = {x: (@sprite.x + @sprite.clip_width), y: @sprite.y}
		@spritenorthwest = {x: @sprite.x, y: @sprite.y}
		@spritesouthwest = {x: @sprite.x, y: (@sprite.y + @sprite.clip_height)}
		@spritesoutheast = {x: (@sprite.x + @sprite.clip_width), y: (@sprite.y + @sprite.clip_height)}
		@gameover = false
	end

	def updateplayerstate(states = {})
		#update player states in general
		states.each { |k, v| Input::INPUTSTATUS[k] = v }
		#improperly piggy backing on constant update to set sprite bounds
		@spriteleft = {x: @sprite.x, y: (@sprite.y + (@sprite.clip_height/2))}
		@spriteright = {x: (@sprite.x + @sprite.clip_width), y: (@sprite.y + (@sprite.clip_height/2))}
		@spriteup = {x: (@sprite.x + (@sprite.clip_width/2)), y: @sprite.y}
		@spritedown = {x: (@sprite.x + (@sprite.clip_width/2)), y: (@sprite.y + @sprite.clip_height)}
		@spritenortheast = {x: (@sprite.x + @sprite.clip_width), y: @sprite.y}
		@spritenorthwest = {x: @sprite.x, y: @sprite.y}
		@spritesouthwest = {x: @sprite.x, y: (@sprite.y + @sprite.clip_height)}
		@spritesoutheast = {x: (@sprite.x + @sprite.clip_width), y: (@sprite.y + @sprite.clip_height)}
	end

	def runanimate(playerstate)
		if !Input::INPUTSTATUS[:gameover]
			if Input::INPUTSTATUS[:collidingdown]
				Input::INPUTSTATUS[:falling] = false
			elsif Input::INPUTSTATUS[:jumping] == false
				Input::INPUTSTATUS[:falling] = true
			end
			if Input::INPUTSTATUS[:falling]
				@sprite.y += 3
			end
			if Input::INPUTSTATUS[:movingright]
				if !Input::INPUTSTATUS[:collidingright]
					@sprite.x += 2
				end
			elsif Input::INPUTSTATUS[:movingleft]
				if !Input::INPUTSTATUS[:collidingleft]
					@sprite.x -= 2
				end
			end
			if Input::INPUTSTATUS[:jumping]
				if !Input::INPUTSTATUS[:collidingup]
					@sprite.y -= 3
				end
			end
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