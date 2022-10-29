extends Area2D

onready var tilled_dirt = $TilledDirt
onready var wet_dirt = $WetDirt
onready var Seed = $Seed
onready var highlight = $Highlight

enum {NATURAL, TILLED, SEEDED, WET, WET_SEEDED}

const DEFAULT_GROWING_TIME = 70
const DEFAULT_NUM_STAGES = 5
const DEFAULT_SPRITE_SIZE = Vector2(16, 16)
const DEFAULT_STARTING_SPRITE = Rect2(16, 0, 16, 16)

var tile
var tile_region
var tile_state = NATURAL setget set_tile_state
var seed_state = {MS.seed_type: MS.none, MS.new: true} setget set_seed_state, get_seed_state
var harvestable: bool = false

func set_tile_state(new_state) -> void:
	tile_state = new_state
	match tile_state:
		NATURAL:
			print("state changed to: NATURAL " + str(new_state))
			wet_dirt.hide()
			tilled_dirt.hide()
		TILLED:
			print("state changed to: TILLED " + str(new_state))
			wet_dirt.hide()
			tilled_dirt.show()
		WET:
			print("state changed to: WET " +  str(new_state))
			wet_dirt.show()
			tilled_dirt.hide()
		SEEDED:
			print("state changed to: SEEDED " + str(new_state))
			wet_dirt.hide()
			tilled_dirt.show()
			if seed_state["new"]:
				add_seed()
			Seed.set_growth_stage()
		WET_SEEDED:
			print("state changed to: WET_SEEDED")
			wet_dirt.show()
			tilled_dirt.hide()
			if seed_state["new"]:
				add_seed()
			Seed.water_seed()

func set_seed_state(new_state) -> void:
	print("seed_state_set: " + str(new_state))
	seed_state = new_state
	
func get_seed_state() -> Dictionary:
	return seed_state

func next_day() -> void:
	match tile_state:
		WET:
			set_tile_state(TILLED)
		WET_SEEDED:
			Seed.next_day()
			set_tile_state(SEEDED)
		SEEDED:
			Seed.next_day()

func add_seed() -> void:
	Seed.texture = load(MS.seed_texture_path.format({MS.seed_type: seed_state[MS.seed_type]})).duplicate()
	Seed.seed_stats = load(MS.seed_stats_path.format({MS.seed_type: seed_state[MS.seed_type]}))
	seed_state[MS.new] = false
	
func remove_seed() -> void:
	Seed.texture = null
	seed_state[MS.new] = true
	set_tile_state(NATURAL)
	
func harvest() -> void:
	Seed.harvest()
	if !Seed.resprouting:
		remove_seed()

func is_harvestable() -> bool:
	return Seed.harvestable

func is_hand_harvestable() -> bool:
	return Seed.hand_harvestable

func is_tool_harvestable() -> bool:
	return Seed.tool_harvestable

func show_highlight() -> void:
	highlight.show()

func hide_highlight() -> void:
	highlight.hide()
