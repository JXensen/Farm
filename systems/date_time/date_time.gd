extends Object
class_name DateTime

# warning-ignore:unused_signal
signal season_changed() # unused signal error from using magic string
# warning-ignore:unused_signal
signal next_day_from_time_passage() # unused signal error from using magic string

enum seasons {Spring, Summer, Fall, Winter}
var season_strings: Dictionary = {seasons.Spring: "Spring", seasons.Summer: "Summer", seasons.Fall: "Fall", seasons.Winter: "Winter"}

enum times {Morning, Afternoon, Evening, Night}
var time_strings: Dictionary = {times.Morning: "Morning", times.Afternoon: "Afternoon", times.Evening: "Evening", times.Night: "Night"}


const MONTH_LENGTH: int = 28
const NUM_MONTHS: int = 4
const STARTING_YEAR: int = 1
const STARTING_DAY_NUM: int = 0 # zero-indexed days for math
const STARTING_DAY_TEXT: int = 1

var num_days: int = STARTING_DAY_NUM
var current_year: int = STARTING_YEAR
var current_season: int = seasons.Spring
var current_day: int = STARTING_DAY_TEXT
var current_time: int = times.Morning

func now() -> String:
	var date_time: String = "{day} of {season}, {time}".format(
		{"day": MS.day_strings[num_days % 28], 
		"season": season_strings[current_season],
		"time": time_strings[current_time] })
	print("year: " + str(current_year) + " day: " + str(current_day) + " time: " + time_strings[current_time])
	return date_time

func add_day() -> String:
	num_days += 1
	current_day = (num_days % MONTH_LENGTH) + 1# +1 changes the math from 0-27 to 1-28, num days is 0 indexed
# warning-ignore:integer_division
	current_year = STARTING_YEAR + (num_days / (MONTH_LENGTH * NUM_MONTHS)) #discard remainder for year math
# warning-ignore:integer_division
	var month_math = (num_days / MONTH_LENGTH) % NUM_MONTHS # discard remainder for month math
	if month_math != current_season:
		current_season = month_math
		emit_signal(MS.season_changed)
	current_time = times.Morning
	return now()

func pass_time() -> String:
	if current_time == times.Night:
		emit_signal(MS.next_day_from_time_passage)
	else:
		current_time = (current_time + 1) % len(times)
	return now()
