extends KinematicBody2D

var state_identifier
export (int) var JUMP_CONSTANT=20
export (int) var jump_force=27
export (int) var movement_speed =20
var vidas
var Life
var collision
var atacando
var jump
var attack
var caida
var muerto
var apreteSaltar
var puedoMoverme = true
var meGolpiaron = false
var puedoSaltar = false
var timer
var sprite
var camera
var AnimationController
var CharacterController
var block

func _ready():
	name = "PlayerMarcos"
	CharacterController = $CharacterController
	AnimationController = $AnimationController
	sprite = get_node("AnimatedSprite")
	camera = get_node("Camera2D")
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
	teclaAtaque()
	$CharacterController.Caer(delta)
	$StateSystem.update_state()

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
	    !meGolpiaron and !meMori() and !attack) :
#		$CharacterController.fuerzaSaltoRestante = $CharacterController.gravedad - 2 //ESTO ERA POR ALGO DEL PJ1, ME OLVIDE QUE, POSIBLEMENTE NO LO NECESITES, ERA TEMA DE ANIMACION
		attack = true
		colisionAtaque()

func Ataque(ray):
	puedoMoverme = false
	yield(get_tree().create_timer(0.3),"timeout") #CUIDADITO WAZOUSKY CUI-DA-DI-TO //Varia segun la velocidad de ataque de tu sprite, tenes que regularlo para que se active justo cuando creas que deberia hacer daño
	ray.enabled = true
	yield(get_tree().create_timer(0.3),"timeout") #CUIDADITO WAZOUSKY CUI-DA-DI-TO //Varia segun la velocidad de ataque de tu sprite, tenes que regularlo para que se desactive para que ya no ataque y no choque contra todo, Estaria bueno que se corresponda con el fin de la animacion
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
	if (Input.is_action_pressed("ui_right") and !muerto and
	    puedoMoverme and !meGolpiaron and !meMori()):
		collision = $CharacterController.Movimiento(1)
	elif (Input.is_action_pressed("ui_left") and !muerto and
	      puedoMoverme and !meGolpiaron and !meMori()):
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
	    !meGolpiaron and !meMori() and !attack and !muerto):
		$CharacterController.Salto(puedoSaltar)

func fuiGolpeado(golpeador):
	$CharacterController.fuerzaSaltoRestante = 0
	Life.perdiVida()
	$Camera2D._on_Player_hit()
	meGolpiaron = true
	yield(get_tree().create_timer(0.5),"timeout")
	meGolpiaron = false
	if Life.vida == 0: morir()

func morir():
	muerto = true
	$CharacterController.gravedad = 0
	$CollisionShape2D.disabled = true
	$AttackCollisionIzq.enabled = false
	$AttackCollisionDer.enabled = false
	name = "Muerto"
	yield(get_tree().create_timer(5),"timeout") #CUIDADITO WAZOUSKY CUI-DA-DI-TO //Varia segun la velocidad de muerte, es el tiempo que queda tu mugroso cadaver hasta que desaparece :v 
	queue_free()
	get_tree().change_scene("res://Scenes/MenuDeEleccionDePersonajes/Selector.tscn")
#	Esto es para ir a la pantalla de seleccion de personaje cuando moris