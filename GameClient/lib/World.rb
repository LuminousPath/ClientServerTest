require './lib/Character.rb'

class World

	@player
	@map

	def initialize(player, map)
		@player = player
		@map = map
		player.sprite.y = (GlobalConfig.config.height) - 97
		player.sprite.play animation: :idle
	end

	def checkplayerstate
		colliding = false

		@map.map.tiles.select { |e| e.collision == true }.each do |collidabletile|
			xoverlap = (@player.sprite.x < (collidabletile.sprite.x + collidabletile.sprite.clip_width)) &&
			((@player.sprite.x + @player.sprite.clip_width) > collidabletile.sprite.x)

			yoverlap = (@player.sprite.y < (collidabletile.sprite.y + collidabletile.sprite.clip_height)) &&
			((@player.sprite.y + @player.sprite.clip_height) > collidabletile.sprite.y)

			if xoverlap && yoverlap
				colliding = true
				break
			end
		end

		if colliding
			@player.updateplayerstate(colliding: true)
		else
			@player.updateplayerstate(colliding: false)
		end

	end

end