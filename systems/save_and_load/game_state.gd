extends Node

var player: KinematicBody2D

enum {OFF, LOOT, TOOL, WEAPON, SPELL, FISH, MINE}
enum tools {NONE, HOE, WATERING_CAN, SEED, TILLER, BASKET}
enum weapons {NONE, SWORD, DAGGER, POLEARM, GUN, BOMB, STAFF, SPEAR, BOLA, SLING, FLAMETHROWER}
enum spells {NONE, EARTH, AIR, FIRE, WATER}

var current_item: item setget set_current_item
var action_state = OFF
var current_tool = tools.NONE
var current_seed = null
var current_weapon = weapons.NONE
var current_spell = spells.NONE
var current_level = "test_level"

func set_current_item(new_item: item) -> void:
	player.tile_focus.change_size(new_item.target_area)
	match new_item.set_type:
		0:
			current_tool = tools.NONE
			current_weapon = weapons.NONE
			current_spell = spells.NONE
		1:
			match new_item.name:
				"blue tulip seed":
					current_tool = tools.SEED
					current_seed = MS.blue_tulip
				"carrot seed":
					current_tool = tools.SEED
					current_seed = MS.carrot
				"tomato seed":
					current_tool = tools.SEED
					current_seed = MS.tomato
				"hoe":
					current_tool = tools.HOE
				"watering can":
					current_tool = tools.WATERING_CAN
				"basket":
					current_tool = tools.BASKET
