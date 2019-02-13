require 'rubygems'
require 'bundler/setup'

require 'ruby2d'
require './lib/Configuration.rb'
require './lib/Character.rb'
require './lib/Input.rb'
require './lib/Network.rb'
require './lib/World.rb'
require './lib/Map.rb'
require './lib/Score.rb'

#Set global configs to make it easier to use contant values throught application
GlobalConfig.config.frametime = 100
GlobalConfig.config.loop = true
GlobalConfig.config.height = 576
GlobalConfig.config.width = 1024
GlobalConfig.config.title = "ジャンプガイ"
GlobalConfig.config.resizable = false
GlobalConfig.config.background = 'blue'
GlobalConfig.config.url = 'http://ubisoft-example.appspot.com/scores'

#set ruby2d constant values
set title: GlobalConfig.config.title
set resizable: GlobalConfig.config.resizable
set height: GlobalConfig.config.height
set width: GlobalConfig.config.width
set background: GlobalConfig.config.background

#create world members
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
score = Score.new('font sprite sheet here','font config here')
#init world
world = World.new(player, map, score)

update do
	if !Input::INPUTSTATUS[:gameover]
		world.checkplayerstate()
		score.updatescore(1)
		if(score.score == 0)
			Input::INPUTSTATUS[:gameover] = true
			next
		end
		player.runanimate(player.state)
	else
		world.gameoverloop
	end
end

#this should be in Input
on :key_held do |event|
	if !Input::INPUTSTATUS[:gameover]
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
		end
	end
end

on :key_up do |event|
	if !Input::INPUTSTATUS[:gameover]
		player.sprite.height = 92
		player.sprite.width = 66
		Input::INPUTSTATUS[:movingright] = false
		Input::INPUTSTATUS[:movingleft] = false
		if Input::INPUTSTATUS[:jumping]
			Input::INPUTSTATUS[:jumping] = false
			Input::INPUTSTATUS[:falling] = true
		end
		player.sprite.play animation: :idle
	end
end

show