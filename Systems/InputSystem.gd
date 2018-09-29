extends Node

func action_pressed(input):
	return Input.is_action_pressed(input)

func is_walking():
	return Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")

func not_walking():
	return !(Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"))