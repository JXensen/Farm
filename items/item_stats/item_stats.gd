extends Resource
class_name item
# items are things that can fit in inventory slots

# item properties
# type
enum {SEED, TOOL, WEAPON, EQUIPMENT, MACHINE, DECOR}

var purchaseable: bool = false
var purchase_price: int = -1

var craftable: bool = false
var ingredients: Array = []

var tier: int = 1
