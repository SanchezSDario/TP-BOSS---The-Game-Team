extends KinematicBody2D

#Determines the animation in the sprite
var state_identifier
export (int) var jump_force

func _ready():
	pass

func _process(delta):
	StateSystem.update_state(self) #Update the state
	MovingSystem.move(self) #Moves the player
	GravitySystem.apply(self, delta)