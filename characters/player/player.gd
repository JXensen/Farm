extends Actor

# sprite animations
const SPRITES:= {"REST": "player_rest", "LEFT": "player_left", "RIGHT": "player_right", 
	"UP": "player_up", "DOWN": "player_down", 
	"FACING_UP": "player_facing_up", "FACING_DOWN": "player_facing_down", 
	"FACING_LEFT": "player_facing_left", "FACING_RIGHT": "player_facing_right"}

onready var idle_timer: Timer = $IdleTimer
onready var tile_focus: CollisionShape2D = $focus_area/tile_focus
onready var player: AnimatedSprite = $player
# player stats and data (for easy save and load)
var stats: character_data setget set_stats
var player_inventory: inventory setget set_inventory


# starts player on it's idle animation
func _ready() -> void:
	player.animation = "player_rest"
	set_stats(preload("res://systems/save_and_load/character_data.tres"))

# player movement
func _physics_process(_delta: float) -> void:
	velocity.x = 0
	velocity.y = 0
	setMovementDirection()
	setFacingDirection()
	if velocity.length() > 0:
		velocity = velocity.normalized() * stats.run_speed
	player.play()
	velocity = move_and_slide(velocity)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
# sets velocity and animation while in motion
# resets the idle delay timer
# sets facing direction for tile focus
func setMovementDirection() -> void:
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if Input.is_action_pressed("ui_right"):
		player.animation = SPRITES["RIGHT"]
		idle_timer.start()
		tile_focus.direction = tile_focus.directions.RIGHT
	elif Input.is_action_pressed("ui_left"):
		player.animation = SPRITES["LEFT"]
		idle_timer.start()
		tile_focus.direction = tile_focus.directions.LEFT
	elif Input.is_action_pressed("ui_down"):
		player.animation = SPRITES["DOWN"]
		idle_timer.start()
		tile_focus.direction = tile_focus.directions.DOWN
	elif Input.is_action_pressed("ui_up"):
		player.animation = SPRITES["UP"]
		idle_timer.start()
		tile_focus.direction = tile_focus.directions.UP
	velocity = input_vector

# sets sprite facing direction while stopped
func setFacingDirection() -> void:
	if Input.is_action_just_released("ui_right"):
		player.animation = SPRITES["FACING_RIGHT"]
	elif Input.is_action_just_released("ui_left"):
		player.animation = SPRITES["FACING_LEFT"]
	elif Input.is_action_just_released("ui_up"):
		player.animation = SPRITES["FACING_UP"]
	elif Input.is_action_just_released("ui_down"):
		player.animation = SPRITES["FACING_DOWN"]

# plays idle animation
func _on_IdleTimer_timeout() -> void:
	player.animation = SPRITES["REST"]
	
func set_stats(new_stats: character_data) -> void:
	stats = new_stats

func set_inventory(new_inventory: inventory) -> void:
	player_inventory = new_inventory 
