tool
extends "res://tools/seasonal_tiles.gd"

signal garden_tile_focused(tile_export, tile_region_export, tile_instance_export)
signal garden_tile_unfocused()
const GARDEN_TILE_ID =  5
var garden_tile = preload("res://levels/interactable_tiles/garden_tile1.tscn")

func _init() -> void:
	tile_type = TILE_TYPES["FLOOR"]

func _ready() -> void:
	var connection_errors:= [0, 0]
	var garden_tiles = get_used_cells_by_id(GARDEN_TILE_ID)
	for tile in garden_tiles:
		var garden_tile_instance = garden_tile.instance()
		garden_tile_instance.position = map_to_world(tile)
		garden_tile_instance.tile = tile
		garden_tile_instance.tile_region = get_cell_autotile_coord(tile[0], tile[1])
		add_child(garden_tile_instance)
		connection_errors[0] = garden_tile_instance.connect("area_entered", self, "garden_tile_area_focused", [garden_tile_instance])
		connection_errors[1] = garden_tile_instance.connect("area_exited", self, "garden_tile_area_unfocused", [garden_tile_instance])
	ErrorHandler.connection_errors("floor_tile._ready", connection_errors)
#_player_focus_area can be used to determine which player is interacting if multiple characters get added MULTIPLAYER
func garden_tile_area_focused(_player_focus_area, tile_instance_export) -> void:
	emit_signal("garden_tile_focused", tile_instance_export)

func garden_tile_area_unfocused(_player_focus_area, tile_instance_export) -> void:
	emit_signal("garden_tile_unfocused", tile_instance_export)

