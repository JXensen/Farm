extends CollisionShape2D

enum directions {LEFT, RIGHT, UP, DOWN}
var direction setget change_direction
onready var rectangle: RectangleShape2D = preload("res://characters/player/tile_focus_rect.tres")
var size: Vector2  = Vector2(1,1) setget change_size 

func change_direction(value) -> void:
	direction = value
	match direction:
		directions.UP:
			change_extents(Vector2(size.y, size.x))
			self.position = Vector2(0, -16 - size.x)
		directions.DOWN:
			change_extents(Vector2(size.y, size.x))
			self.position = Vector2(0, 16 + size.x)
		directions.LEFT:
			change_extents(size)
			self.position = Vector2(-16 - size.x, 0)
		directions.RIGHT:
			change_extents(size)
			self.position = Vector2(16 + size.x, 0)

func change_size(value: Vector2) -> void:
	size = value
	change_direction(direction)
	if value == Vector2(0,0):
		self.disabled = true
	else:
		self.disabled = false

	
func change_extents(value: Vector2) -> void:
	rectangle.extents = value
