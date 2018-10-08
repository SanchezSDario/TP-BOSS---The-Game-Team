extends Node

var caster

func move():
	move_left()
	move_right()

func jump():
	caster.jump_force = caster.JUMP_CONSTANT

func move_right():
	caster.collision = caster.move_and_collide(Vector2(caster.movement_speed, 0))

func move_left():
	caster.collision = caster.move_and_collide(Vector2(-caster.movement_speed, 0))
