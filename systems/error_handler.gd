extends Node

func error(function_name: String, error_code: int):
	push_error("Error code: " + str(error_code) + " on " + function_name)

func connection_errors(function_name: String, error_codes: Array) -> void:
	for error in error_codes:
		if error:
			push_error("Connection error on " + function_name)


