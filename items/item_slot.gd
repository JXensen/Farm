extends Sprite

# TEMP
signal initialize_item_slot(slot_number, item_stats)

export var item_stats: Resource = preload("res://items/item_stats/none_item.tres")
export var slot_number: int

func _ready():
	emit_signal("initialize_item_slot", slot_number, item_stats)
