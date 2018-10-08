extends KinematicBody2D

var state_identifier
export (int) var JUMP_CONSTANT
export (int) var jump_force
export (int) var movement_speed
var collision
var jump

func _ready():
	set_meta("Type", "Enemy")
	$MovingSystem.caster = self

func _process(delta):
	$GravitySystem.apply(delta)
	aproach_to_player()

func aproach_to_player():
	aproach_left()
	aproach_right()

func aproach_left():
	if($RayCast2D.is_colliding() 
	and $RayCast2D.get_collider().get_meta("Type") == "Player"):
		$MovingSystem.move_left()
		collide_player()

func aproach_right():
	if($RayCast2D2.is_colliding() 
	and $RayCast2D2.get_collider().get_meta("Type") == "Player"):
		$MovingSystem.move_right()
		collide_player()

func collide_player():
	if(collision != null and collision.collider.get_meta("Type") == "Player"):
		collision.collider.queue_free()