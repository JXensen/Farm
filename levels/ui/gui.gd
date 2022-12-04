extends CanvasLayer

onready var floor_tiles = self.get_parent().find_node(State.current_level)

onready var clock = $clock
onready var toolbar = $toolbar
onready var player = $"../player"
# TEMP
onready var temp_button: Button = $Button

enum {OFF, LOOT, TOOL, WEAPON, SPELL, FISH, MINE}
enum tools {NONE, HOE, WATERING_CAN, SEED, TILLER, BASKET}
enum weapons {NONE, SWORD, DAGGER, POLEARM, GUN, BOMB, STAFF, SPEAR, BOLA, SLING, FLAMETHROWER}
enum spells {NONE, EARTH, AIR, FIRE, WATER}

var action_state = OFF

var focused_tile_instances: Array
 
func _ready() -> void:
	var connection_errors:= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	connection_errors[0] = floor_tiles.connect("garden_tile_focused", self, "on_garden_tile_focused")
	connection_errors[1] = floor_tiles.connect("garden_tile_unfocused", self, "on_garden_tile_unfocused")
	connection_errors[2] = temp_button.connect("pressed", clock, "next_day")
	ErrorHandler.connection_errors("gui._ready", connection_errors)
	State.player = player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		print("action")     
		match action_state:
			TOOL:
				match State.current_tool:
					tools.NONE:
						for tile_instance in focused_tile_instances:
							if tile_instance.is_hand_harvestable() and tile_instance.is_harvestable():
								tile_instance.harvest()
					tools.BASKET:
						for tile_instance in focused_tile_instances:
							if tile_instance.is_tool_harvestable() and tile_instance.is_harvestable():
								tile_instance.harvest()
					tools.HOE:
						for tile_instance in focused_tile_instances:
							match tile_instance.tile_state:
								tile_instance.NATURAL:
									tile_instance.tile_state = tile_instance.TILLED
					tools.SEED:
						for tile_instance in focused_tile_instances:
							match tile_instance.tile_state:
								tile_instance.TILLED:
									tile_instance.seed_state["seed_type"] = State.current_seed
									tile_instance.tile_state = tile_instance.SEEDED
								tile_instance.WET:
									tile_instance.seed_state["seed_type"] = State.current_seed
									tile_instance.tile_state = tile_instance.WET_SEEDED
					tools.WATERING_CAN:
						for tile_instance in focused_tile_instances:
							match tile_instance.tile_state:
								tile_instance.TILLED:
									tile_instance.tile_state = tile_instance.WET
								tile_instance.SEEDED:
									tile_instance.tile_state = tile_instance.WET_SEEDED
			OFF:
				pass
	elif event.is_action_pressed("scroll_up"):
		toolbar.scroll_item_selection_up()
	elif event.is_action_pressed("scroll_down"):
		toolbar.scroll_item_selection_down()
		
func on_garden_tile_focused(tile_instance_import):
	action_state = TOOL
	focused_tile_instances.append(tile_instance_import)
	tile_instance_import.show_highlight()

func on_garden_tile_unfocused(tile_instance_import):
	focused_tile_instances.erase(tile_instance_import)
	if focused_tile_instances.empty():
		action_state = OFF
	tile_instance_import.hide_highlight()
