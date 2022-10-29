extends CanvasLayer

onready var floor_tiles = self.get_parent().find_node(current_level)
onready var temp_button: Button = $Button
# TEMP
onready var hoe_button: Button = $hoe
onready var water_button: Button = $watering_can
onready var carrot_seed: Button = $carrot_seed
onready var pumpkin_seed: Button = $pumpkin_seed
onready var blue_tulip_seed: Button = $tulip_seed
onready var no_tool_button: Button = $no_tool
onready var basket_button: Button = $basket

enum {OFF, LOOT, TOOL, WEAPON, SPELL, FISH, MINE}
enum tools {NONE, HOE, WATERING_CAN, SEED, TILLER, BASKET}
enum weapons {NONE, SWORD, DAGGER, POLEARM, GUN, BOMB, STAFF, SPEAR, BOLA, SLING, FLAMETHROWER}
enum spells {NONE, EARTH, AIR, FIRE, WATER}

var action_state = OFF
var current_tool = tools.NONE
var current_seed = null
var current_weapon = weapons.NONE
var current_spell = spells.NONE
var current_level = "test_level"

var focused_tiles: Array
var focused_tile_regions: Array 
var focused_tile_instances: Array

var temp_button_idx: int = 0
 
func _ready() -> void:
	var connection_errors:= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	connection_errors[0] = floor_tiles.connect("garden_tile_focused", self, "on_garden_tile_focused")
	connection_errors[1] = floor_tiles.connect("garden_tile_unfocused", self, "on_garden_tile_unfocused")
	connection_errors[2] = temp_button.connect("pressed", floor_tiles, "changeDay")
	connection_errors[3] = hoe_button.connect("pressed", self, "hoe_button_pressed")
	connection_errors[4] = water_button.connect("pressed", self, "watering_can_button_pressed")
	connection_errors[5] = carrot_seed.connect("pressed", self, "carrot_seed_button_pressed")
	connection_errors[6] = pumpkin_seed.connect("pressed", self, "pumpkin_seed_button_pressed")
	connection_errors[7] = blue_tulip_seed.connect("pressed", self, "blue_tulip_seed_button_pressed")
	connection_errors[8] = no_tool_button.connect("pressed", self, "no_tool_button_pressed")
	connection_errors[9] = basket_button.connect("pressed", self, "basket_button_pressed")
	ErrorHandler.connection_errors("gui._ready", connection_errors)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		print("action")     
		match action_state:
			TOOL:
				match current_tool:
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
									tile_instance.seed_state["seed_type"] = current_seed
									tile_instance.tile_state = tile_instance.SEEDED
								tile_instance.WET:
									tile_instance.seed_state["seed_type"] = current_seed
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
		
		
func on_garden_tile_focused(tile_instance_import):
	action_state = TOOL
	focused_tile_instances.append(tile_instance_import)
	tile_instance_import.show_highlight()

func on_garden_tile_unfocused(tile_instance_import):
	focused_tile_instances.erase(tile_instance_import)
	if focused_tiles.empty():
		action_state = OFF
	tile_instance_import.hide_highlight()

func get_garden_tile_state():
	pass
func set_garden_tile_state():
	pass

func hoe_button_pressed():
	current_tool = tools.HOE
	$"../player".tile_focus.change_size(Vector2(1,1))

func watering_can_button_pressed():
	current_tool = tools.WATERING_CAN
	$"../player".tile_focus.change_size(Vector2(1,1))

func carrot_seed_button_pressed():
	current_tool = tools.SEED
	current_seed = MS.carrot
	$"../player".tile_focus.change_size(Vector2(1,1))

func pumpkin_seed_button_pressed():
	current_tool = tools.SEED
	current_seed = MS.tomato
	$"../player".tile_focus.change_size(Vector2(1,1))
	
func blue_tulip_seed_button_pressed():
	current_tool = tools.SEED
	current_seed = MS.blue_tulip
	$"../player".tile_focus.change_size(Vector2(1,1))

func no_tool_button_pressed():
	current_tool = tools.NONE
	$"../player".tile_focus.change_size(Vector2(1,1))

func basket_button_pressed():
	current_tool = tools.BASKET
	$"../player".tile_focus.change_size(Vector2(36,36))
