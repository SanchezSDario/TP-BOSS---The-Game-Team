extends KinematicBody2D

#Determines the animation in the sprite
var state_identifier
export (int) var JUMP_CONSTANT
export (int) var jump_force
export (int) var movement_speed
var collision
var jump
var attack

func _ready():
	attack = false
	jump = false
	set_meta("Type", "Player")

func _process(delta):
	$GravitySystem.apply(delta) #Applies gravitation
	collision()
	attack()
	$MovingSystem.execute()
	$StateSystem.update_state() #Update the state

func collision():
	if(collision != null):
		match collision.collider.get_meta("Type"):
			"Floor": jump = false
			"Enemy": queue_free()


func attack():
	if(InputSystem.action_just_pressed("ui_attack")):
		attack = true
	if(attack and ($AnimatedSprite.frame > 4 and $AnimatedSprite.frame < 6)):
		$AttackCollision.disabled = false
	if(attack and $AnimatedSprite.frame == 9):
		$AttackCollision.disabled = true
		attack = false