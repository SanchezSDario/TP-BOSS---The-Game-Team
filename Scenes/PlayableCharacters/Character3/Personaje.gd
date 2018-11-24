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
var useDash
var timerDash
var stopDash = true
var audioEspadazo
var invulnerable
var audioDaniado
var audioGolpieEnemigo
var audioDash

func _ready():
	audioEspadazo = get_node("Espadazo")
	audioDaniado = get_node("Herido")
	audioDash = get_node("Dash")
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
	timerDash = Timer.new()
	timerDash.wait_time = 0.3
	timerDash.connect("timeout",self,"terminoDash")
	add_child(timerDash)
	audioGolpieEnemigo = get_node("GolpieEnemigo")
	#self.remove_child(camera)
	#get_parent().add_child(camera)

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
	Dash()
	testBoss()
	

func meMori():
	return Life.vida <=  0
	



func golpieAlguien(ray):
	if ray.is_colliding() and ray.get_collider() != null and ray.get_collider() != null and ray.get_collider().name.begins_with("Enemy"):
		ray.enabled = false
		CharacterController.Golpie(ray.get_collider(),"Enemy",self)
		if ray.get_collider() != null and ray.get_collider().name.begins_with("Enemy"):
			audioGolpieEnemigo.play(0)
		
		
func colisionAtaque():
	if AnimationController.Flip():
		Ataque(rayder)
	else:
		Ataque(ray)
		
func Movimientos():
	if Input.is_action_pressed("ui_right") and puedoMoverme and !meGolpiaron and !meMori() and !useDash:
		collision = CharacterController.Movimiento(1)	
		AnimationController.CaminandoDerecha()
		collisionShape.position.x = -5
		
	elif Input.is_action_pressed("ui_left") and puedoMoverme and !meGolpiaron and !meMori() and !useDash:
		collision = CharacterController.Movimiento(-1)	
		AnimationController.CaminandoIzquierda()
		collisionShape.position.x = 1
	else:
		AnimationController.Normal()

func terminoDash():
	useDash = false
	stopDash = true
	self.collisionShape.disabled = false
	self.CharacterController.gravedad = self.CharacterController.gravedadGuardada
	

func Dash():
	if Input.is_action_just_pressed("ui_control") and !meMori() and Life.powerUp > 0:	
		audioDash.play(0)
		Life.powerUp -= 1
		AnimationController.sprite.emitir()
		CharacterController.fuerzaSaltoRestante = 0
		CharacterController.gravedad = 0
		collisionShape.disabled = true
		useDash = true
		stopDash = false
		timerDash.start()
		AnimationController.animacion.play("Dash")
	if !stopDash and AnimationController.sprite.flip_h:
		CharacterController.Movimiento(5)
	elif !stopDash:
		CharacterController.Movimiento(-5)
		
		
func teclaAtaque():
	if Input.is_action_just_pressed("ui_accept")  and !meGolpiaron and !meMori() and !useDash :
		AnimationController.Ataque()
		colisionAtaque()

func caer():
	caida = CharacterController.Gravedad()

func testBoss():
	if Input.is_action_just_pressed("0"):
		print("fuim")
		self.position.x = 8000
		
func Ataque(ray):
	puedoMoverme = false
	yield(get_tree().create_timer(0.2),"timeout")
	ray.enabled = true
	audioEspadazo.play(0)
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
		if self.AnimationController.sprite.flip_h and self.position.y < caida.collider.global_position.y  :
		#	self.position.y -= 6
			self.position.x += 3
		elif self.position.y < caida.collider.global_position.y :
			self.position.x -= 3
			
	if caida != null and caida.collider.name.begins_with("EnemyEs"):
		#Parche
		if self.AnimationController.sprite.flip_h and self.position.y < caida.collider.global_position.y :
		#	self.position.y -= 6
			self.position.x += 3
		elif self.position.y < caida.collider.global_position.y :
			self.position.x -= 3
		#	self.position.y -= 6
		
		
func Mori():
	self.visible = false
	yield(get_tree().create_timer(3),"timeout")
	get_tree().change_scene("res://Scenes/MenuDeEleccionDePersonajes/Selector.tscn")
 	
func fuiGolpeado(golpeador):
	print("AY")	
	if !invulnerable:
		audioDaniado.play(0)
		invulnerable = true
		CharacterController.fuerzaSaltoRestante -= 3
		Life.perdiVida()
		meGolpiaron = true
		AnimationController.Tirado(Life.vida)
		camera._on_Player_hit()
		if Life.vida == 0:
			timer.start()
			set_process(false)
			self.vidas -= 1
			collisionShape.disabled = true
			
		
		
			

		
func terminoCaida():
	if AnimationController.terminoAnimacion("Tirado") :
		meGolpiaron = false	
		invulnerable = false

		
	