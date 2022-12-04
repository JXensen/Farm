extends Sprite
class_name plant_seed
#--------------------
enum {FLOWER, TREE, CROP, SHRUB}
#--------------------
var plant_type:= CROP
var num_stages: int = 6
const DISTANCE_BETWEEN_WET_AND_DRY = 6
#--------------------
var growing_time: int = 70 setget set_growing_time
var stage_1_growing_time: int = -1
var stage_2_growing_time: int = -1
var stage_3_growing_time: int = -1
var stage_4_growing_time: int = -1
var resprouting: bool = false
var resprout_stage: int = 6
#--------------------
var hand_harvestable: bool = false
var tool_harvestable: bool = false
var harvest_tool = "NONE"
#--------------------
var sprite_size: Vector2 = Vector2(16, 16)
var starting_sprite: Rect2 = Rect2(sprite_size.x, 0, sprite_size.x, sprite_size.y)
#--------------------
var wet: bool = false
var dryness: int = 0
var dryness_threshold: int = 3
var dryness_regression: int = 5
var age: int = 0
var growth_stage: int = 0
var harvestable: bool = false 
var dead: bool = false

var seed_stats: seed_stats setget set_seed_stats
var seed_item_stats: item setget set_seed_item_stats, get_seed_item_stats

func set_growing_time(new_time: int) -> void:
	print("growing time: " + str(new_time))
	growing_time = new_time
	# warning-ignore:integer_division
	stage_1_growing_time = new_time / 4
	assert(stage_1_growing_time > 0)
	# warning-ignore:integer_division
	stage_2_growing_time = new_time / 2
	stage_3_growing_time = stage_1_growing_time + stage_2_growing_time
	if num_stages == 5:
		stage_4_growing_time = new_time
	else:
		stage_4_growing_time = new_time - 1
	print("stage 4 growing time: " + str(stage_4_growing_time))

func water_seed() -> void:
	wet = true
	region_rect = (Rect2((region_rect.position + Vector2(DISTANCE_BETWEEN_WET_AND_DRY * sprite_size.x, 0)), starting_sprite.size))
	print("water region: " + str(region_rect))

func next_day() -> void:
	if wet:
		age += 1
		wet = false
		region_rect = (Rect2(region_rect.position - Vector2(DISTANCE_BETWEEN_WET_AND_DRY * sprite_size.x, 0), starting_sprite.size))
		print("dry region: " + str(region_rect))
		print("age: " + str(age))
	else:
		dryness_increases()
		print("dryness: " + str(dryness) + " dryness threshold: " + str(dryness_threshold))
	set_growth_stage()

func set_growth_stage() -> void:
	if age < 0:
		plant_death()
		return
	if age == 0:
			growth_stage = 0
	elif age <= stage_1_growing_time:
			growth_stage = 1
	elif age <= stage_2_growing_time:
			growth_stage = 2
	elif age <= stage_3_growing_time:
			growth_stage = 3
	elif age <= stage_4_growing_time:
			growth_stage = 4
			if num_stages == 5:
				harvestable = true
	elif age >= growing_time and !harvestable:
			harvestable = true
			growth_stage = 5
	print("growth stage: " + str(growth_stage))
	update_growth_stage_sprite()

func dryness_increases() -> void:
	dryness += 1
	if dryness == dryness_threshold:
		dryness = 0
		age -= dryness_regression
		print("age after dryness: " + str(age))
		set_growth_stage()

func plant_death() -> void:
	print("ded")
	dead = true

func update_growth_stage_sprite() -> void:
	region_rect.position.x = starting_sprite.position.x + (growth_stage * sprite_size.x)
	print("texture region: " + str(region_rect))

func set_sprite_size(new_size) -> void:
	sprite_size = new_size
	starting_sprite = Rect2(sprite_size.x, 0, sprite_size.x, sprite_size.y)

func harvest() -> void:
	if resprouting:
		match resprout_stage:
			0:
				age = 0
			1:
				# warning-ignore:integer_division
				age = growing_time/4
			2:
				# warning-ignore:integer_division
				age = growing_time/2
			3:
				# warning-ignore:integer_division
				# warning-ignore:integer_division
				age = growing_time/4 + growing_time/2
			4:
				age = growing_time - 1
		set_growth_stage()
		if wet:
			water_seed()
	harvestable = false

func set_seed_stats(new_stats) -> void:
	age = 0
	plant_type = new_stats.plant_type
	num_stages = new_stats.num_stages
	set_growing_time(new_stats.growing_time)
	hand_harvestable = new_stats.hand_harvestable
	tool_harvestable = new_stats.tool_harvestable
	harvest_tool = new_stats.harvest_tool
	sprite_size = new_stats.sprite_size
	dryness_threshold = new_stats.dryness_threshold
	dryness_regression = new_stats.dryness_regression
	resprouting = new_stats.resprouting
	resprout_stage = new_stats.resprout_stage

func set_seed_item_stats(new_stats) -> void:
	seed_item_stats = new_stats
	# something like "if new_stats.item_tier > 1: set_seed_stats(better_stats)

func get_seed_item_stats() -> item:
	return seed_item_stats
