extends KinematicBody2D

var state_identifier
var moving
var jumping

func _ready():
	pass

func _process(delta):
	StateSystem.update_state(self)
	MovingSystem.move(self)

func move():
	MovingSystem.move(self)