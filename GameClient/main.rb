require 'ruby2d'
require './lib/Configuration.rb'
require './lib/Character.rb'

set title: "ジャンプガイ"
set resizable: false
set height: 576
set width: 1024

GlobalConfig.config.frametime = 100
GlobalConfig.config.loop = true

Player = Character.new('resources/Sprites/p1_spritesheet.png', 'resources/Sprites/p1_spritesheet.xml')

Player.sprite.y = (get :height) - 97
Player.sprite.play animation: :idle

inputstatus = { movingleft: false, movingright: false, jumping: false, ducking: false, falling: false}

on :key_held do |event|
	case event.key
		when 'left'
			Player.sprite.height = 97
			Player.sprite.width = 72
			inputstatus[:movingleft] = true
			Player.sprite.play animation: :walk, loop: true, flip: :horizontal
		when 'right'
			Player.sprite.height = 97
			Player.sprite.width = 72
			inputstatus[:movingright] = true
			Player.sprite.play animation: :walk, loop: true
		when 'up'
			Player.sprite.height = 94
			Player.sprite.width = 67
			unless inputstatus[:falling]
				inputstatus[:jumping] = true
			end
			if inputstatus[:movingleft]
				Player.sprite.play animation: :jump, loop: false, flip: :horizontal
			else
				Player.sprite.play animation: :jump, loop: false
			end
		when 'down'
			Player.sprite.height = 71
			Player.sprite.width = 66
			inputstatus[:ducking] = true
			Player.sprite.play animation: :duck, loop: false
	end
end

on :key_up do |event|
	Player.sprite.height = 92
	Player.sprite.width = 66
	inputstatus[:movingright] = false
	inputstatus[:movingleft] = false
	if inputstatus[:jumping]
		inputstatus[:jumping] = false
		inputstatus[:falling] = true
	end
	inputstatus[:ducking] = false
	Player.sprite.play animation: :idle
end

update do
	if Player.sprite.y >= (get :height) - 97
		Player.sprite.y = (get :height) - 97
		inputstatus[:falling] = false
	end
	if inputstatus[:falling]
		Player.sprite.y += 3
	end
	if inputstatus[:movingright]
		Player.sprite.x += 1
	elsif inputstatus[:movingleft]
		Player.sprite.x -= 1
	end
	if inputstatus[:jumping]
		Player.sprite.y -= 3
	end
end

show