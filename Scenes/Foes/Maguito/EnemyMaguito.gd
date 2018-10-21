extends KinematicBody2D
export(PackedScene) var bala
var AnimationController
var CharacterController
var timer
var puedoDisparar = true
var rayder
var rayizq
var voyAtacar = false
var estoyMuriendo = false
var collision
var rayAtaqueDer
var rayAtaqueIzq
var collisionShape
var life 
export var puntaje = 0
var timerMuerte
func _ready():
	life = get_node("Life")
	collisionShape = get_node("CollisionShape2D")
	AnimationController = get_node("AnimatedSpriteController")
	CharacterController = get_node("CharacterController")
	timer = Timer.new()
	timer.wait_time = 1
	timer.connect("timeout",self,"puedoDisparar")
	add_child(timer)
	timerMuerte = Timer.new()
	timerMuerte.wait_time = 15
	timerMuerte.connect("timeout",self,"borrar")
	add_child(timerMuerte)
	rayder = get_node("rayder")
	rayizq = get_node("rayizq")
	rayAtaqueDer = get_node("rayAtaqueDer")
	rayAtaqueIzq = get_node("rayAtaqueIzq")

	
	
func _process(delta):
	seguidores()
	CharacterController.Gravedad()
	Atacar()

func borrar():
	self.queue_free()
	
func seguidores():
	if rayder.is_colliding() and rayder.get_collider().name.begins_with("Player")and !voyAtacar and !estoyMuriendo and !rayder.get_collider().meMori():
		collision = CharacterController.Movimiento(1)
		AnimationController.CaminandoDerecha()
		
		
	elif rayizq.is_colliding() and rayizq.get_collider().name.begins_with("Player") and !voyAtacar and !estoyMuriendo and !rayizq.get_collider().meMori():
		collision = CharacterController.Movimiento(-1)
		AnimationController.CaminandoIzquierda()
		
	else:
		AnimationController.Normal()	

func Atacar():
	if rayAtaqueDer.is_colliding() and rayAtaqueDer.get_collider().name.begins_with("Player")and !voyAtacar and !estoyMuriendo and !rayAtaqueDer.get_collider().meMori():
		disparar(40,false)
		
	elif rayAtaqueIzq.is_colliding() and rayAtaqueIzq.get_collider().name.begins_with("Player") and !voyAtacar and !estoyMuriendo and !rayAtaqueIzq.get_collider().meMori():
		disparar(-40,true)
		
		
func fuiGolpeado(golpeador):
	life.vida -= 1
	if life.vida > 0:
		var gravedadAnterior = CharacterController.gravedad
		puedoDisparar = false
		collisionShape.disabled = true
		collisionShape.position.x += 1000
		CharacterController.gravedad = 0
		estoyMuriendo = true
		AnimationController.Golpeado()
		yield(get_tree().create_timer(1),"timeout")
		puedoDisparar = true 
		estoyMuriendo = false
		collisionShape.disabled = false
		collisionShape.position.x -= 1000
		AnimationController.animacion.play("Normal")
	else:
		puedoDisparar = false
		estoyMuriendo = true
		CharacterController.gravedad = 0
		self.collisionShape.disabled = true
		collisionShape.position.x += 1000
		AnimationController.estoyMuriendo = true
		AnimationController.muerte()
		timerMuerte.start()
		GameManager.puntaje += puntaje		
	
func disparar(pos,izquierda):
	if puedoDisparar:
		voyAtacar = true
		timer.start()
		AnimationController.Ataque()
		yield(get_tree().create_timer(1),"timeout")
		if puedoDisparar:
			puedoDisparar = false
			var scene_instance = bala
			scene_instance = scene_instance.instance()
			scene_instance.set_name("Bala")
			add_child(scene_instance)
			scene_instance.position.x += pos
			scene_instance.irALaIzquierda = izquierda
		voyAtacar = false
	
	
func puedoDisparar():
	puedoDisparar = true
		


