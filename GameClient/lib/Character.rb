require 'ruby2d'
require 'xmlsimple'

class Character
	attr_reader :sprite

	def initialize(spritesheet, configloc)

		charconfig = CharacterConfig.new(configloc)

		@sprite = Sprite.new(
			spritesheet,
			time: GlobalConfig.config.frametime,
			loop: GlobalConfig.config.loop,
			animations: charconfig.animationset
		)
	end
end

class CharacterConfig
	attr_reader :animationconfig,  :animationset

	def initialize(configloc)
		@animationconfig = characterSpriteSheetConfig = XmlSimple.xml_in(open(configloc))

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