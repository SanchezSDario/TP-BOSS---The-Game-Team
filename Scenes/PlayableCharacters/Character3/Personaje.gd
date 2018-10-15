extends KinematicBody2D


var CharacterController
var AnimationController
var collisionShape
var ray 
var rayder
var collision
var apreteSaltar
var puedoSaltar = false
var caida
var puedoMoverme = true
func _ready():
	ray = get_node("CharacterController/RayCast2D")
	rayder = get_node("CharacterController/RayCast2D2")
	CharacterController = get_node("CharacterController")
	AnimationController = get_node("AnimationController")
	collisionShape = get_node("CollisionShape2D")
	set_meta("Type","Player")
	pass

func _process(delta):
	caer()
	Movimientos()
	golpieAlguien(ray)
	golpieAlguien(rayder)
	Cayendo()
	puedoSaltar()
	Salto()
	CharacterController.Caer(delta)

func golpieAlguien(ray):
	if ray.is_colliding():
		ray.enabled = false
		CharacterController.Golpie(ray.get_collider(),"Enemy")
		
func colisionAtaque():
	if AnimationController.Flip():
		Ataque(rayder)
	else:
		Ataque(ray)
		
func Movimientos():
	if Input.is_action_pressed("ui_right") and puedoMoverme:
		collision = CharacterController.Movimiento(1)	
		AnimationController.CaminandoDerecha()
		collisionShape.position.x = -5
		
	elif Input.is_action_pressed("ui_left") and puedoMoverme:
		collision = CharacterController.Movimiento(-1)	
		AnimationController.CaminandoIzquierda()
		collisionShape.position.x = 1
		
	elif Input.is_action_just_pressed("ui_accept") and puedoSaltar:
		AnimationController.Ataque()
		colisionAtaque()
	else:
		AnimationController.Normal()
		

func caer():
	caida = CharacterController.Gravedad()
		
func Ataque(ray):
	puedoMoverme = false
	yield(get_tree().create_timer(0.4),"timeout")
	ray.enabled = true
	yield(get_tree().create_timer(0.4),"timeout")
	ray.enabled = false
	puedoMoverme = true

func Cayendo():
	if 	!puedoSaltar:
		AnimationController.Salto(!puedoSaltar)
		
func Salto():
	if Input.is_action_just_pressed("ui_up"):
		CharacterController.Salto(puedoSaltar)

func puedoSaltar():
	if caida != null :
		puedoSaltar = true
		apreteSaltar = false
	else:
		puedoSaltar = false		
		
func recibiGolpe():
	print("AY")	
