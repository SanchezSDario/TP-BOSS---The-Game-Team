extends KinematicBody2D

#Determines the animation in the sprite
var state_identifier
export (int) var JUMP_CONSTANT
export (int) var jump_force
export (int) var movement_speed
var collision
var jump

func _ready():
	jump = false
	set_meta("Type", "Player")

func _process(delta):
	$GravitySystem.apply(delta) #Applies gravitation
	collision()
	$MovingSystem.execute()
	$StateSystem.update_state() #Update the state

func collision():
	if(collision != null):
		match collision.collider.get_meta("Type"):
			"Floor": jump = false
			"Enemy": queue_free()