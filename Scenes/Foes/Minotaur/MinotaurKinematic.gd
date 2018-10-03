extends KinematicBody2D

var state_identifier
export (int) var JUMP_CONSTANT
export (int) var jump_force
export (int) var movement_speed
var collision
var jump

func _ready():
	set_meta("Type", "Enemy")
	pass

func _process(delta):
	StateSystem.update_state(self) #Update the state
	MovingSystem.execute(self) #Moves the player
	CollisionSystem.execute(self)


#func _on_Area2D_body_entered(body):
#	CollisionSystem.execute(self)