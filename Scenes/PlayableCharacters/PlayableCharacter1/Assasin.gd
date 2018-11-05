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
			"Enemy": collide_enemy()

func collide_enemy():
	if(!attack): queue_free()

# Executes attack logic
func attack():
	attack_event()
	turn_attack_on()
	turn_attack_off()

#Detects if input attack was pressed
func attack_event():
	if(InputSystem.action_just_pressed("ui_attack")): attack = true

#Activates the attack collision
func turn_attack_on():
	if(attack and 
	  ($AnimatedSprite.frame > 4 and
	   $AnimatedSprite.frame < 6)):
		attack_left_or_right()

func attack_left_or_right():
	if($AnimatedSprite.flip_h): $AttackCollision2.disabled = false
	else: $AttackCollision.disabled = false

#Disable the attack collision
func turn_attack_off():
	if(attack and $AnimatedSprite.frame == 9):
		$AttackCollision.disabled = true
		$AttackCollision2.disabled = true
		attack = false