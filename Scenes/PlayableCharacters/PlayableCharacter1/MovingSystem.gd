extends "res://Systems/MovingSystem/MovingSystem.gd"

func _ready():
	caster = get_parent()

func execute():
	if(InputSystem.action_pressed("ui_right")): .move_right()
	if(InputSystem.action_pressed("ui_left")): .move_left()
	if(can_jump()):jump()

func jump():
	caster.jump = true
	.jump()

func can_jump():
	return (InputSystem.action_just_pressed("ui_up") and caster.jump == false)