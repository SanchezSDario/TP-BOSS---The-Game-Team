extends Node

var caster

func _ready():
	caster = get_parent()

func execute():
	jump()
	move()

func move():
	move_left()
	move_right()

func jump():
	if(InputSystem.action_just_pressed("ui_up") and !caster.jump):
		caster.jump_force = caster.JUMP_CONSTANT
		caster.jump = true

func move_right():
	if(InputSystem.action_pressed("ui_right")):
		caster.collision = caster.move_and_collide(Vector2(caster.movement_speed, 0))
		jump()

func move_left():
	if(InputSystem.action_pressed("ui_left")):
		caster.collision = caster.move_and_collide(Vector2(-caster.movement_speed, 0))
		jump()