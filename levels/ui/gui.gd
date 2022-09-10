extends CanvasLayer

onready var floor_tiles = self.get_parent().find_node(current_level)
onready var temp_button: Button = $Button
# TEMP
onready var player_tile_focus = get_parent().find_node("player").find_node("focus_area").find_node("tile_focus")

enum {OFF, LOOT, TOOL, WEAPON, SPELL, FISH, MINE}
enum tools {NONE, HOE, WATERING_CAN, SEED, TILLER}
enum weapons {NONE, SWORD, DAGGER, POLEARM, GUN, BOMB, STAFF, SPEAR, BOLA, SLING, FLAMETHROWER}
enum spells {NONE, EARTH, AIR, FIRE, WATER}

var action_state = OFF
var current_tool = tools.HOE
var current_weapon = weapons.NONE
var current_spell = spells.NONE
var current_level = "test_level"

var focused_tiles: Array
var focused_tile_regions: Array 
var focused_tile_instances: Array

var temp_button_idx: int = 0
 
func _ready() -> void:
	var connection_errors:= [0, 0, 0]
	connection_errors[0] = floor_tiles.connect("garden_tile_focused", self, "on_garden_tile_focused")
	connection_errors[1] = floor_tiles.connect("garden_tile_unfocused", self, "on_garden_tile_unfocused")
	connection_errors[2] = temp_button.connect("pressed", player_tile_focus, "change_size", [Vector2(32,1)])
	ErrorHandler.connection_errors("gui._ready", connection_errors)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		print("action")     
		match action_state:
			TOOL:
				match current_tool:
					tools.HOE:
						for tile_instance in focused_tile_instances:
							match tile_instance.tile_state:
								tile_instance.NATURAL:
									tile_instance.tile_state = tile_instance.TILLED
					tools.SEED:
						for tile_instance in focused_tile_instances:
							match tile_instance.tile_state:
								tile_instance.TILLED:
									tile_instance.tile_state = tile_instance.SEEDED
								# TODO add seeded sprite to soil, set seed state
								tile_instance.WET:
									tile_instance.tile_state = tile_instance.WET_SEEDED
					tools.WATERING_CAN:
						for tile_instance in focused_tile_instances:
							match tile_instance.tile_state:
								tile_instance.TILLED:
									tile_instance.tile_state = tile_instance.WET
								tile_instance.SEEDED:
									tile_instance.tile_state = tile_instance.WET_SEEDED
								# TODO add wet seeded sprite to soil
			OFF:
				pass
		
		
func on_garden_tile_focused(tile_instance_import):
	action_state = TOOL
	focused_tile_instances.append(tile_instance_import)

func on_garden_tile_unfocused(tile_instance_import):
	focused_tile_instances.erase(tile_instance_import)
	if focused_tiles.empty():
		action_state = OFF

func get_garden_tile_state():
	pass
func set_garden_tile_state():
	pass

