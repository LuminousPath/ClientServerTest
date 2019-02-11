require 'ruby2d'
require './lib/Configuration.rb'
require './lib/Character.rb'
require './lib/Input.rb'
require './lib/Network.rb'
require './lib/World.rb'
require './lib/Map.rb'

GlobalConfig.config.frametime = 100
GlobalConfig.config.loop = true
GlobalConfig.config.height = 576
GlobalConfig.config.width = 1024
GlobalConfig.config.title = "ジャンプガイ"
GlobalConfig.config.resizable = false
GlobalConfig.config.background = 'blue'

set title: GlobalConfig.config.title
set resizable: GlobalConfig.config.resizable
set height: GlobalConfig.config.height
set width: GlobalConfig.config.width
set background: GlobalConfig.config.background

map = Map.new(
	'resources/Sprites/tiles_spritesheet.png',
	'resources/Sprites/tiles_spritesheet.xml',
	'resources/Sprites/items_spritesheet.png',
	'resources/Sprites/items_spritesheet.xml',
	'resources/Map.xml'
	)
player = Character.new(
	'resources/Sprites/p1_spritesheet.png',
	'resources/Sprites/p1_spritesheet.xml'
	)
world = World.new(player, map)

update do
	world.checkplayerstate()
	player.runanimate(player.state)
end

on :key_held do |event|
	case event.key
		when 'left'
			player.sprite.height = 97
			player.sprite.width = 72
			Input::INPUTSTATUS[:movingleft] = true
			player.sprite.play animation: :walk, loop: true, flip: :horizontal
		when 'right'
			player.sprite.height = 97
			player.sprite.width = 72
			Input::INPUTSTATUS[:movingright] = true
			player.sprite.play animation: :walk, loop: true
		when 'up'
			player.sprite.height = 94
			player.sprite.width = 67
			unless Input::INPUTSTATUS[:falling]
				Input::INPUTSTATUS[:jumping] = true
			end
			if Input::INPUTSTATUS[:movingleft]
				player.sprite.play animation: :jump, loop: false, flip: :horizontal
			else
				player.sprite.play animation: :jump, loop: false
			end
		when 'down'
			player.sprite.height = 71
			player.sprite.width = 66
			Input::INPUTSTATUS[:ducking] = true
			player.sprite.play animation: :duck, loop: false
	end
end

	on :key_up do |event|
		player.sprite.height = 92
		player.sprite.width = 66
		Input::INPUTSTATUS[:movingright] = false
		Input::INPUTSTATUS[:movingleft] = false
		if Input::INPUTSTATUS[:jumping]
			Input::INPUTSTATUS[:jumping] = false
			Input::INPUTSTATUS[:falling] = true
		end
		Input::INPUTSTATUS[:ducking] = false
		player.sprite.play animation: :idle
	end

show