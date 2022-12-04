extends CanvasLayer

onready var item0: Sprite = $item0
onready var item1: Sprite = $item1
onready var item2: Sprite = $item2
onready var item3: Sprite = $item3
onready var item4: Sprite = $item4
onready var item5: Sprite = $item5
onready var item6: Sprite = $item6
onready var item7: Sprite = $item7
onready var item8: Sprite = $item8

onready var highlight: ColorRect = $selection_highlight

onready var item_sprite_list = [item0, item1, item2, item3, item4, item5, item6, item7, item8]
var selected_item: int = 0

const HIGHLIGHT_START_X_POSITION: int = 324
const DISTANCE_BETWEEN_ITEMS: int = 44
const ITEM_SPRITE_SIZE: int = 16
const NUM_ITEMS: int = 9
const MINUS_ONE: int = NUM_ITEMS - 1

func _ready():
	# TEMP initialize empty item slots
	var connection_errors = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	for error in range(0, len(connection_errors)):
		connection_errors[error] = item_sprite_list[error].connect(MS.initialize_item_slot, self, "change_item_info")
		item_sprite_list[error]._ready()
		ErrorHandler.connection_errors("toolbar._ready", connection_errors)
	# TEMP set some starting tools in the hotbar manually
	change_item_info(0, preload("res://items/item_stats/tool_stats/basket_item.tres"))
	change_item_info(1, preload("res://items/item_stats/tool_stats/hoe_item.tres"))
	change_item_info(2, preload("res://items/item_stats/tool_stats/watering_can_item.tres"))
	change_item_info(3, preload("res://items/item_stats/seed_stats/blue_tulip_seed_item.tres"))
	change_item_info(4, preload("res://items/item_stats/seed_stats/carrot_seed_item.tres"))
	change_item_info(5, preload("res://items/item_stats/seed_stats/tomato_seed_item.tres"))


func change_item_selection(item_number: int) -> void:
	selected_item = item_number
	pass_selected_item_to_state()
	highlight.rect_position.x = HIGHLIGHT_START_X_POSITION + (item_number * DISTANCE_BETWEEN_ITEMS)
	
func scroll_item_selection_up() -> void:
	selected_item = (selected_item + 1) % NUM_ITEMS
	change_item_selection(selected_item)

func scroll_item_selection_down() -> void:
	selected_item = (selected_item + MINUS_ONE) % NUM_ITEMS
	change_item_selection(selected_item)

func change_item_info(item_number: int, item_stats: item) -> void:
	var item_sprite: Sprite = item_sprite_list[item_number]
	item_sprite.item_stats = item_stats
	item_sprite.texture = item_stats.sprite
	item_sprite.region_rect.position = Vector2(item_stats.sprite_coords.x * ITEM_SPRITE_SIZE, item_stats.sprite_coords.y * ITEM_SPRITE_SIZE)

func pass_selected_item_to_state() -> void:
	State.current_item = item_sprite_list[selected_item].item_stats
