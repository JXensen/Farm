extends Area2D

onready var tilled_dirt = $TilledDirt
onready var wet_dirt = $WetDirt

enum {NATURAL, TILLED, SEEDED, WET, WET_SEEDED}

var tile
var tile_region
var tile_state = NATURAL setget set_tile_state
var seed_state = {"seed_type": "NONE", "seed_stage": "NONE"} setget set_seed_state, get_seed_state

func set_tile_state(new_state) -> void:
	tile_state = new_state
	match tile_state:
		TILLED:
			print("state changed to: TILLED " + str(new_state))
			tilled_dirt.show()
		WET:
			print("state changed to: WET" +  str(new_state))
			wet_dirt.show()
			tilled_dirt.hide()
		SEEDED:
			# TODO set type/stage related sprite
			pass
		WET_SEEDED:
			wet_dirt.show()
			tilled_dirt.hide()
			# TODO set type/stage related sprite
			

func set_seed_state(new_state) -> void:
	seed_state = new_state
	
func get_seed_state() -> Dictionary:
	return seed_state

func next_day() -> void:
	match tile_state:
		WET:
			set_tile_state(TILLED)
		WET_SEEDED:
			seed_state["seed_stage"] += 1
			set_tile_state(SEEDED)
