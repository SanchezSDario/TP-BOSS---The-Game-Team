extends Node

func execute(caster):
	jump(caster)
	move(caster)

func jump(caster):
	if(InputSystem.action_just_pressed("ui_up") and !caster.jump):
		caster.jump_force = caster.JUMP_CONSTANT
		caster.jump = true

func move(caster):
	move_left(caster)
	move_right(caster)

func move_right(caster):
	if(InputSystem.action_pressed("ui_right")):
		caster.collision = caster.move_and_collide(Vector2(caster.movement_speed, 0))
		jump(caster)

func move_left(caster):
	if(InputSystem.action_pressed("ui_left")):
		caster.collision = caster.move_and_collide(Vector2(-caster.movement_speed, 0))
		jump(caster)