require './lib/Character.rb'

class World

	@player
	@map
	@score
	@gameoverscreen = false
	@gamescoresent = false

	def initialize(player, map, score)
		@player = player
		@map = map
		@score = score
		player.sprite.y = 430
		player.sprite.x = 10
		player.sprite.play animation: :idle
	end

	def checkplayerstate
		#this is checked every update, so set the colliding flags to false
		collidingdown = false
		collidingright = false
		collidingleft = false
		collidingup = false
		collidingnortheast = false
		collidingnorthwest = false
		collidingsoutheast = false
		collidingsouthwest = false
		gameover = false
		playerstate = {
			collidingdown: false,
			collidingright: false,
			collidingleft: false,
			collidingup: false,
			gameover: false}

		#giant collision container select statement
		#there must be a way to short-circuit this
		overlaptiles = @map.map.tiles.select do |tile|
			tile.sprite.contains?(@player.spriteleft[:x], @player.spriteleft[:y]) ||
			tile.sprite.contains?(@player.spriteright[:x], @player.spriteright[:y]) ||
			tile.sprite.contains?(@player.spriteup[:x], @player.spriteup[:y]) ||
			tile.sprite.contains?(@player.spritedown[:x], @player.spritedown[:y]) ||
			tile.sprite.contains?(@player.spritenortheast[:x], @player.spritenortheast[:y]) ||
			tile.sprite.contains?(@player.spritenorthwest[:x], @player.spritenorthwest[:y]) ||
			tile.sprite.contains?(@player.spritesoutheast[:x], @player.spritesoutheast[:y]) ||
			tile.sprite.contains?(@player.spritesouthwest[:x], @player.spritesouthwest[:y])
		end.select { |e| e.collision == true || e.gameover == true}.each do |collidingtile|
			#set gameover tile state
			if collidingtile.gameover
				if @player.sprite.contains?((collidingtile.sprite.x + (collidingtile.sprite.clip_width/2)),
						(collidingtile.sprite.y + (collidingtile.sprite.clip_height/2)))
					gameover = true
				end
			end
			#set collision points
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spriteleft[:x], @player.spriteleft[:y])
				collidingleft = true
			end
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spriteright[:x], @player.spriteright[:y])
				collidingright = true
			end
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spriteup[:x], @player.spriteup[:y])
				collidingup = true
			end
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spritedown[:x], @player.spritedown[:y])
				collidingdown = true
			end
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spritenortheast[:x], @player.spritenortheast[:y])
				collidingnortheast = true
			end
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spritenorthwest[:x], @player.spritenorthwest[:y])
				collidingnorthwest = true
			end
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spritesoutheast[:x], @player.spritesoutheast[:y])
				collidingsoutheast = true
			end
			if collidingtile.collision && collidingtile.sprite.contains?(@player.spritesouthwest[:x], @player.spritesouthwest[:y])
				collidingsouthwest = true
			end
			#set slidable conditions (corner collision)
			if collidingsoutheast && !collidingdown
				collidingright = true
			end
			#make sure this one is last
			if collidingsoutheast || collidingsouthwest
				collidingdown = true
			end

		end

		#make the player land first
		if gameover && !collidingdown
			gameover = false
		end

		playerstate[:collidingup] = collidingup
		playerstate[:collidingdown] = collidingdown
		playerstate[:collidingleft] = collidingleft
		playerstate[:collidingright] = collidingright
		playerstate[:gameover] = gameover

		#transmit state to player object
		@player.updateplayerstate(playerstate)

	end

	#runs when the game state changes to gameover
	def gameoverloop
		playernumber = 0
		if @player.gameover == false
			@player.sprite.play animation: :jump
			@player.gameover = true
		end
		if !@gameoverscreen
			playernumber = rand(9999999999)
			gameoverscreen = Rectangle.new(
				x: 0, y: 0,
				width: GlobalConfig.config.width,
				height: GlobalConfig.config.height,
				color: 'black',
				z: 5
			)
			gameoverscore = Text.new(
				  "PLAYER #{playernumber} SCORE: #{@score.score}",
				  x: GlobalConfig.config.width/2 - 190, y: GlobalConfig.config.height/2,
				  size: 30,
				  color: 'white',
				  z: 10
				)
			@gameoverscreen = true
		end
		if !@gamescoresent
			sendingtext = Text.new(
				  "Sending Score...",
				  x: GlobalConfig.config.width/2 - 70, y: GlobalConfig.config.height/2 + 50,
				  size: 30,
				  color: 'white',
				  z: 10
				)
			#this needs much better error handling and retry states
			if Network.addscore(playernumber.to_s, @score.score)
				sendingtext.text = "Sent Score"
			else
				sendingtext.text = "Error Sending Score"
			end
			@gamescoresent = true
		end
	end

end