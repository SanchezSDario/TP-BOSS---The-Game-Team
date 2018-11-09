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
var sprite
var Life
var vidas

func _ready():
	Life = get_node("Life")

	ray = get_node("RayCast2D")
	rayder = get_node("RayCast2D2")
	CharacterController = get_node("CharacterController")
	AnimationController = get_node("AnimationController")
	collisionShape = get_node("CollisionShape2D")
	set_meta("Type","Player")
	camera = get_node("Camera2D")
	timer = Timer.new()
	timer.wait_time = 1.4
	add_child(timer)
	timer.connect("timeout",self,"Mori")
	sprite= get_node("AnimationController/Sprite")

func _process(delta):
	vidas = Life.vida
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
	return Life.vida ==  0
	
	

func golpieAlguien(ray):
	if ray.is_colliding() and ray.get_collider() != null and ray.get_collider() != null and ray.get_collider().name.begins_with("Enemy"):

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
	
	if caida != null and caida.collider.name.begins_with("Enemy") and !caida.collider.name.begins_with("EnemyBarril")  :
		CharacterController.fuerzaSaltoRestante -= 1
		if self.AnimationController.sprite.flip_h and self.position.y < caida.collider.position.y   :
			self.position.x += 3
		elif self.position.y < caida.collider.position.y :
			self.position.x -= 3
	if caida != null and caida.collider.name.begins_with("EnemyEs"):
		#Parche
		if self.AnimationController.sprite.flip_h and self.position.y < caida.collider.position.y +90  :
			self.position.x += 3
		elif self.position.y < caida.collider.position.y +90 :
			self.position.x -= 3
		
		
func Mori():
	self.visible = false
 	
func fuiGolpeado(golpeador):
	print("AY")	
	CharacterController.fuerzaSaltoRestante = 0
	Life.perdiVida()
	meGolpiaron = true
	AnimationController.Tirado(Life.vida)
	camera._on_Player_hit()
	if Life.vida == 0:
		timer.start()
		
		
			

		
func terminoCaida():
	if AnimationController.terminoAnimacion("Tirado") :
		CharacterController.gravedad = CharacterController.gravedadGuardada
		meGolpiaron = false	

		
	