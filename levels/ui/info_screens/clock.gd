extends CanvasLayer

onready var date_time_label: Label = $date_time_label
onready var timer: Timer = $Timer

var date_time: DateTime = DateTime.new()


func _ready():
	var connection_errors = [0, 0, 0]
	connection_errors[0] = timer.connect(MS.timeout, self, MS.pass_time)
	connection_errors[1] = date_time.connect(MS.season_changed, self, MS.next_season)
	connection_errors[2] = date_time.connect(MS.next_day_from_time_passage, self, "next_day")
	set_time_label(date_time.now())
	next_season()
	ErrorHandler.connection_errors("clock._ready", connection_errors)

func next_day() -> void:
	# all NEXT DAY functions should be gathered here
	get_tree().call_group(MS.garden_tiles , MS.next_day)
	timer.start() # shouldn't be halfway through morning at the start of the next day
	set_time_label(date_time.add_day())
	
func next_season() -> void:
	# all NEXT SEASON functions should be gathered here
	get_tree().call_group(MS.tile_sets, MS.change_tile_set, date_time.current_season)
	
func pass_time() -> void:
	set_time_label(date_time.pass_time())

func set_time_label(current_time: String):
	date_time_label.text = current_time
