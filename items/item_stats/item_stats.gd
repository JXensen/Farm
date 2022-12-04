extends Resource
class_name item
# items are things that can fit in inventory slots

# item properties
# type
enum type {NONE = 0, TOOL = 1, WEAPON = 2, EQUIPMENT = 3, MACHINE = 4, DECOR = 5, PRODUCT = 6}

export var name: String = ""
export var set_type: int = type.NONE

export var purchaseable: bool = false
export var purchase_price: int = -1

export var craftable: bool = false
export var ingredients: Dictionary = {}

export var tier: int = 1

export var sprite: Texture = preload("res://assets/ui/items.png")
export var sprite_coords: Vector2 = Vector2(0,0)

export var target_area: Vector2 = Vector2(0,0)
