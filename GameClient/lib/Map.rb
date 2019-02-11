require 'xmlsimple'

class Map
	attr_accessor :map

	def initialize(tilespritesheet, tilespritesheetconfig, itemspritesheet, itemspritesheetconfig, maplayoutconfig)
		@itemsprite = ItemConfig.new(itemspritesheet, itemspritesheetconfig)
		@mapsprite = TileConfig.new(tilespritesheet, tilespritesheetconfig)

		@map = MapConfig.new(@itemsprite, @mapsprite, maplayoutconfig)
	end

end

class MapConfig
	attr_accessor :tiles

	def initialize(itemconfig, tileconfig, maplayoutconfig)
		maplayout = XmlSimple.xml_in(open(maplayoutconfig))
		spritey = 0-(((maplayout["Row"].count*tileconfig.tileheight) - GlobalConfig.config.height)/2)
		spritex = 0-(((maplayout["Row"][0]["Tile"].count * tileconfig.tilewidth) - GlobalConfig.config.width)/2)
		@tiles = []

		maplayout["Row"].each do |row|
			row["Tile"].each do |tile|
				sprite = Sprite.new(
					tileconfig.spritesheet,
					time: 100,
					loop: true,
					x: spritex,
					y: spritey,
					z: 1,
					width: tileconfig.tilewidth,
					height: tileconfig.tileheight,
					animations: tileconfig.tileset
				)
				@tiles.push(Tile.new(sprite, (tile["collide"] == "true")))
				sprite.play animation: tile["name"].to_sym
				spritex += tileconfig.tilewidth
			end
			spritex = 0-(((maplayout["Row"][0]["Tile"].count * tileconfig.tilewidth) - GlobalConfig.config.width)/2)
			spritey += tileconfig.tileheight
		end

	end
end

class ItemConfig
	attr_reader :spritesheet, :spriteset

	def initialize(spritesheet, spritesheetconfig)
		@spritesheet = spritesheet
		itemconfig = XmlSimple.xml_in(open(spritesheetconfig))

		@spriteset = itemconfig["SubTexture"].map do |subtexture|
			[
				subtexture["name"].to_sym,
				{
					:x => subtexture["x"].to_i,
					:y => subtexture["y"].to_i,
					:height => subtexture["height"].to_i,
					:width => subtexture["width"].to_i
				}
			]
		end
	end
end

class TileConfig
	attr_reader :spritesheet, :tileset, :tilewidth, :tileheight

	def initialize(tilesheet, tilesheetconfig)
		@spritesheet = tilesheet
		mapconfig = XmlSimple.xml_in(open(tilesheetconfig))

		@tilewidth = mapconfig["SubTexture"][0]["width"].to_i
		@tileheight = mapconfig["SubTexture"][0]["height"].to_i

		@tileset = mapconfig["SubTexture"].map do |subtexture|
			[
				subtexture["name"].to_sym,
				[{
					:x => subtexture["x"].to_i,
					:y => subtexture["y"].to_i,
					:height => subtexture["height"].to_i,
					:width => subtexture["width"].to_i
				}]
			]
		end.to_h
	end
end

class Tile
	attr_accessor :sprite, :collision

	def initialize(sprite, collision)
		@sprite = sprite
		@collision = collision
	end
end