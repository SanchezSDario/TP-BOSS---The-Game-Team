extends Node

func jump(caster):
	pass

func move(caster):
	move_left(caster)
	move_right(caster)

func move_right(caster):
	if(InputSystem.action_pressed("ui_right")):
		caster.position.x += 1

func move_left(caster):
	if(InputSystem.action_pressed("ui_left")):
		caster.position.x -= 1