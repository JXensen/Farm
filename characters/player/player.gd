extends Actor

# sprite animations
const SPRITES = {"REST": "player_rest", "LEFT": "player_left", "RIGHT": "player_right", 
	"UP": "player_up", "DOWN": "player_down", 
	"FACING_UP": "player_facing_up", "FACING_DOWN": "player_facing_down", 
	"FACING_LEFT": "player_facing_left", "FACING_RIGHT": "player_facing_right"}
# idle animation delay (in frames)
export var DELAY_AMOUNT = 240
var delay = DELAY_AMOUNT

# starts player on it's idle animation
func _ready():
	$player.animation = "player_rest"
	screen_size = get_viewport_rect().size

# player movement
func _process(delta: float) -> void:	
	velocity.x = 0
	velocity.y = 0
	setMovementDirection()
	setFacingDirection()
	idleAnimationDelay()
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	$player.play()
	velocity = move_and_slide(velocity)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# resets the delay timer
func resetDelay():
	delay = DELAY_AMOUNT
	
# sets velocity and animation while in motion, resets the idle delay timer
func setMovementDirection():
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$player.animation = SPRITES["RIGHT"]
		resetDelay()
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$player.animation = SPRITES["LEFT"]
		resetDelay()
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		$player.animation = SPRITES["DOWN"]
		resetDelay()
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		$player.animation = SPRITES["UP"]
		resetDelay()

# sets facing direction while stopped
func setFacingDirection():
	if Input.is_action_just_released("ui_right"):
		$player.animation = SPRITES["FACING_RIGHT"]
	elif Input.is_action_just_released("ui_left"):
		$player.animation = SPRITES["FACING_LEFT"]
	elif Input.is_action_just_released("ui_up"):
		$player.animation = SPRITES["FACING_UP"]
	elif Input.is_action_just_released("ui_down"):
		$player.animation = SPRITES["FACING_DOWN"]

# starts the idle animation after the specified delay (reset by moving)
func idleAnimationDelay():
	delay -= 1
	if delay <= 0:
		$player.animation = SPRITES["REST"]

