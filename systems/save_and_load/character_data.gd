class_name character_data
extends Resource

export var name:= "Player"
export var run_speed:= 100.0



export var farming_experience:= 0
export var mining_experience:= 0
export var insect_experience:= 0
export var total_experience: int = farming_experience + mining_experience + insect_experience

# integer division to keep the level at a whole number
# +1 to start at level 1
export var level: int = (total_experience / 1000) + 1 #warning-ignore:integer_division

export var strength:= 5
export var endurance:= 5
export var charisma:= 5
