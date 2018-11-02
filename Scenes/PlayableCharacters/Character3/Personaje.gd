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
var meGolpiaron = false
var camera
var timer
var EnElAire

func _ready():
	ray = get_node("CharacterController/RayCast2D")
	rayder = get_node("CharacterController/RayCast2D2")
	CharacterController = get_node("CharacterController")
	AnimationController = get_node("AnimationController")
	collisionShape = get_node("CollisionShape2D")
	set_meta("Type","Player")
	camera = get_node("Camera2D")
	timer = Timer.new()
	timer.wait_time = 1.4
	add_child(timer)
	timer.connect("timeout",self,"Mori")

func _process(delta):
	caer()
	Movimientos()
	golpieAlguien(ray)
	golpieAlguien(rayder)
	Cayendo()
	puedoSaltar()
	Salto()
	CharacterController.Caer(delta)
	terminoCaida()
	teclaAtaque()
	rebote()

func meMori():
	if GameManager.vidas ==  0:
		return true
	else:
		return false
	

func golpieAlguien(ray):
	if ray.is_colliding() and ray.get_collider() != null and ray.get_collider().name.begins_with("Enemy"):

		ray.enabled = false
		CharacterController.Golpie(ray.get_collider(),"Enemy",self)
		
		
func colisionAtaque():
	if AnimationController.Flip():
		Ataque(rayder)
	else:
		Ataque(ray)
		
func Movimientos():
	if Input.is_action_pressed("ui_right") and puedoMoverme and !meGolpiaron and !meMori():
		collision = CharacterController.Movimiento(1)	
		AnimationController.CaminandoDerecha()
		collisionShape.position.x = -5
		
	elif Input.is_action_pressed("ui_left") and puedoMoverme and !meGolpiaron and !meMori():
		collision = CharacterController.Movimiento(-1)	
		AnimationController.CaminandoIzquierda()
		collisionShape.position.x = 1
	else:
		AnimationController.Normal()
		
func teclaAtaque():
	if Input.is_action_just_pressed("ui_accept")  and !meGolpiaron and !meMori() :
		AnimationController.Ataque()
		colisionAtaque()

func caer():
	caida = CharacterController.Gravedad()

		
func Ataque(ray):
	puedoMoverme = false
	yield(get_tree().create_timer(0.2),"timeout")
	ray.enabled = true
	yield(get_tree().create_timer(0.2),"timeout")
	ray.enabled = false
	puedoMoverme = true

func Cayendo():
	if 	!puedoSaltar:
		AnimationController.Salto(!puedoSaltar)
		
func Salto():
	if Input.is_action_just_pressed("ui_up") and !meGolpiaron and !meMori():
		CharacterController.Salto(puedoSaltar)

func puedoSaltar():
	if caida != null :
		puedoSaltar = true
		apreteSaltar = false
	elif caida == null or caida != null and !caida.collider.name.begins_with("Enemy"):
		puedoSaltar = false		

func rebote():
	if caida != null and caida.collider.name.begins_with("Enemy")  :
		CharacterController.fuerzaSaltoRestante -= 3
		if self.AnimationController.sprite.flip_h and self.position.y < caida.collider.position.y  :
			self.position.x += 3
		elif self.position.y < caida.collider.position.y :
			self.position.x -= 3
func Mori():
	self.queue_free()
 	
func fuiGolpeado(golpeador):
	CharacterController.fuerzaSaltoRestante = 0
	print("AY")	
	GameManager.vidas -= 1
	meGolpiaron = true
	AnimationController.Tirado(GameManager.vidas)
	camera._on_Player_hit()
	if GameManager.vidas == 0:
		timer.start()
		
		
			

		
func terminoCaida():
	if AnimationController.terminoAnimacion("Tirado") :
		meGolpiaron = false	

		
	