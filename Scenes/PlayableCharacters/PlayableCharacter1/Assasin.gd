extends KinematicBody2D

#Determines the animation in the sprite
var state_identifier
export (int) var JUMP_CONSTANT
export (int) var jump_force
export (int) var movement_speed
var collision
var jump

func _ready():
	pass

func _process(delta):
	StateSystem.update_state(self) #Update the state
	MovingSystem.execute(self) #Moves the player
	GravitySystem.apply(self, delta) #Applies gravitation
	CollisionSystem.execute(self)