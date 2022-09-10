extends KinematicBody2D
class_name Actor

# everything that moves has... velocity, speed, and uses the same screen size
var velocity:= Vector2.ZERO
export var speed:= 100
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
