extends KinematicBody2D

#Determines the animation in the sprite
var state_identifier
export (int) var JUMP_CONSTANT
export (int) var jump_force
export (int) var movement_speed
var vidas
var Life
var collision
var atacando
var jump
var attack
var caida
var block
var muerto
var soporte
var resistencia = -2
var apreteSaltar
var puedoMoverme = true
var meGolpiaron = false
var puedoSaltar = false
var timer

func _ready():
	name = "PlayerCaballero"
	vidas = $Life.vida
	Life = $Life
	attack = false
	jump = false
	set_meta("Type", "Player")

func _process(delta):
	fall()
	collision()
	golpieAlguien($AttackCollisionIzq)
	golpieAlguien($AttackCollisionDer)
	move()
	puedoSaltar()
	jump()
	block()
	soportar_golpe(delta)
	teclaAtaque()
	$CharacterController.Caer(delta)
	$StateSystem.update_state() #Update the state

func golpieAlguien(ray):
	if (ray.is_colliding() and
	    ray.get_collider() != null and
	    ray.get_collider().name.begins_with("Enemy")):
		ray.enabled = false
		$CharacterController.Golpie(ray.get_collider(),"Enemy",self)

func colisionAtaque():
	if $AnimatedSprite.flip_h: Ataque($AttackCollisionIzq)
	else: Ataque($AttackCollisionDer)

func teclaAtaque():
	if (Input.is_action_just_pressed("ui_attack") and 
	    !meGolpiaron and
	    !meMori()) :
		attack = true
		colisionAtaque()

func Ataque(ray):
	puedoMoverme = false
	yield(get_tree().create_timer(0.3),"timeout")
	ray.enabled = true
	yield(get_tree().create_timer(0.3),"timeout")
	ray.enabled = false
	attack = false
	puedoMoverme = true

func fall():
	caida = $CharacterController.Gravedad()

func meMori():
	return GameManager.vidas ==  0

func collision():
	if(collision != null): jump = false

func move():
	if (Input.is_action_pressed("ui_right") and
	    puedoMoverme and
		!meGolpiaron and
		!meMori()):
		collision = $CharacterController.Movimiento(1)
	elif (Input.is_action_pressed("ui_left") and
	      puedoMoverme and
		  !meGolpiaron and
		  !meMori()):
		collision = $CharacterController.Movimiento(-1)

func puedoSaltar():
	if caida != null:
		puedoSaltar = true
		apreteSaltar = false
	elif (caida == null or
	      caida != null and
		  !caida.collider.name.begins_with("Enemy")):
		puedoSaltar = false

func jump():
	if (Input.is_action_just_pressed("ui_up") and
	    !meGolpiaron and
		!meMori()):
		$CharacterController.Salto(puedoSaltar)

func fuiGolpeado(golpeador):
	if(!block):
		$CharacterController.fuerzaSaltoRestante = 0
		Life.perdiVida()
		print(Life.vida)
		$Camera2D._on_Player_hit()
		meGolpiaron = true
		yield(get_tree().create_timer(0.5),"timeout")
		meGolpiaron = false
		if Life.vida == 0: morir()
	else:
		soporte = true

func morir():
	muerto = true
	$CharacterController.gravedad = 0
	$CollisionShape2D.disabled = true
	$AttackCollisionIzq.enabled = false
	$AttackCollisionDer.enabled = false
	name = "Muerto"
	yield(get_tree().create_timer(5),"timeout")
	queue_free()

func soportar_golpe(delta):
	if(soporte):
		if($AnimatedSprite.flip_h):
			resistencia -= 2 * delta
			move_and_collide (-4 *Vector2(sin(resistencia),0))
		else:
			resistencia -= 2 * delta
			move_and_collide (4 *Vector2(sin(resistencia),0))
		yield(get_tree().create_timer(0.5),"timeout")
		soporte = false
		resistencia = -2

func block():
	if(Input.is_action_just_pressed("ui_block")):
		print("Block!")
		$CharacterController.gravedad = 0
		block = true
		state_identifier = "Block"
		yield(get_tree().create_timer(1),"timeout")
		$CharacterController.gravedad = 20
		block = false