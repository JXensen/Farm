tool
extends TileMap

# set by child classes
var tile_type
# season prefixes and tile types
const SEASONS = ["spring_", "summer_", "fall_", "winter_"]
const TILE_TYPES = {"FLOOR": "tiles.tres", "CLIFFS": "cliffs.tres", 
	"DECOR": "decor.tres"}

# sets the tile set by loading the resource string with the season and tile type
func changeTileSet(season: int):
	set_tileset(load("res://levels/tilesets/" + SEASONS[season] + tile_type))
