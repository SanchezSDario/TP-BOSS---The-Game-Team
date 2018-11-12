extends KinematicBody2D

#Determines the animation in the sprite
var state_identifier
export (int) var JUMP_CONSTANT
export (int) var jump_force
export (int) var movement_speed
var vidas
var Life
var collision
var jump
var attack
var caida
var apreteSaltar
var puedoMoverme = true
var meGolpiaron = false
var puedoSaltar = false

func _ready():
	name = "PersonajeCaballero"
	vidas = $Life.vida
	Life = $Life
#	$AttackCollision2.disabled = true
#	$AttackCollision.disabled = true
	attack = false
	jump = false
	set_meta("Type", "Player")

func _process(delta):
	fall()
	collision()
	golpieAlguien($AttackCollisionIzq)
	golpieAlguien($AttackCollisionDer)
#	attack()
	move()
	puedoSaltar()
	jump()
	teclaAtaque()
	$CharacterController.Caer(delta)
	$StateSystem.update_state() #Update the state

func golpieAlguien(ray):
	if ray.is_colliding() and ray.get_collider() != null and ray.get_collider() != null and ray.get_collider().name.begins_with("Enemy"):

		ray.enabled = false
		$CharacterController.Golpie(ray.get_collider(),"Enemy",self)

func colisionAtaque():
	if $AnimatedSprite.flip_h:
		Ataque($AttackCollisionIzq)
	else:
		Ataque($AttackCollisionDer)

func teclaAtaque():
	if Input.is_action_just_pressed("ui_attack")  and !meGolpiaron and !meMori() :
		attack = true
		colisionAtaque()

func Ataque(ray):
	puedoMoverme = false
	yield(get_tree().create_timer(0.5),"timeout")
	ray.enabled = true
	yield(get_tree().create_timer(0.5),"timeout")
	ray.enabled = false
	attack = false
	puedoMoverme = true

func fall():
	caida = $CharacterController.Gravedad()

func meMori():
	return GameManager.vidas ==  0

func collision():
	if(collision != null):
		match collision.collider.get_meta("Type"):
			"Floor": jump = false

func move():
	if Input.is_action_pressed("ui_right") and puedoMoverme and !meGolpiaron and !meMori():
		collision = $CharacterController.Movimiento(1)
	elif Input.is_action_pressed("ui_left") and puedoMoverme and !meGolpiaron and !meMori():
		collision = $CharacterController.Movimiento(-1)

func puedoSaltar():
	if caida != null:
		puedoSaltar = true
		apreteSaltar = false
	elif caida == null or caida != null and !caida.collider.name.begins_with("Enemy"):
		puedoSaltar = false

func jump():
	if Input.is_action_just_pressed("ui_up") and !meGolpiaron and !meMori():
		$CharacterController.Salto(puedoSaltar)

func fuiGolpeado(golpeador):
	$CharacterController.fuerzaSaltoRestante = 0
	print("AY")
	GameManager.vidas -= 1
	$Camera2D._on_Player_hit()
	meGolpiaron = true
	yield(get_tree().create_timer(0.5),"timeout")
	meGolpiaron = false
#	if GameManager.vidas == 0:
#		timer.start()

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
	if($AnimatedSprite.flip_h):
#		$CharacterController.Golpie(ray.get_collider(),"Enemy",self)
		$AttackCollision2.disabled = false
	else:
#		$CharacterController.Golpie(ray.get_collider(),"Enemy",self)
		$AttackCollision.disabled = false

#Disable the attack collision
func turn_attack_off():
	if(attack and $AnimatedSprite.frame == 9):
		$AttackCollision.disabled = true
		$AttackCollision2.disabled = true
		attack = false