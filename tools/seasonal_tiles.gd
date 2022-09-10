tool
extends TileMap

# TODO move season/total_seasons to game state when implemented
var total_seasons = 1
var season = 1
var days = 1
# set by child classes
var tile_type
# season prefixes and tile types
const SEASONS = ["spring_", "summer_", "fall_", "winter_"]
const TILE_TYPES = {"FLOOR": "tiles.tres", "CLIFFS": "cliffs.tres", 
	"DECOR": "decor.tres", "INTERACTABLE": "interactable.tres"}

# on ready sets the tile set to match the current season variable
func _ready():
	changeTileSet()
	
# when the day clicks over, un-water tiles
func changeDay() -> void:
	days += 1
	for tile in get_tree().get_nodes_in_group("garden_tiles"):
		tile.next_day()

# when the season changes, change the tile sets
func changeSeason():
	total_seasons += 1
	season = (total_seasons) % 4
	changeTileSet()

# sets the tile set by loading the resource string with the season and tile type
func changeTileSet():
	set_tileset(load("res://levels/tilesets/" + SEASONS[season] + tile_type))
