extends "res://Systems/MovingSystem/MovingSystem.gd"

func ready():
	caster = get_parent()

func execute():
	move_left()
	move_right()