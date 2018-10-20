extends KinematicBody2D
var rayAtaqueIzq
var rayAtaqueDer
var CharacterController
var AnimationController
var collisionShape
var seguidorDer
var seguidorIzq
var collision
var voyAtacar = false
var estoyAtacando = false
var estoyMuriendo = false
var timer
var life
export var puntaje = 0

func _ready():
	timer = Timer.new()
	timer.wait_time = 15
	add_child(timer)
	timer.connect("timeout",self,"borrar")
	set_meta("Type" ,"Enemy")
	rayAtaqueIzq = get_node("rayAtaqueIzq")
	rayAtaqueDer = get_node("rayAtaqueDer")
	seguidorDer = get_node("SeguidorDer")
	seguidorIzq = get_node("SeguidorIzq")
	CharacterController = get_node("CharacterController")
	AnimationController = get_node("SpriteAnimatedController")
	collisionShape = get_node("CollisionShape2D")
	life = get_node("Life")



func _process(delta):
	seguidores()
	CharacterController.Gravedad()
	Atacar(rayAtaqueDer)
	Atacar(rayAtaqueIzq)

func borrar():
	self.queue_free()

		
func seguidores():
	if seguidorDer.is_colliding() and seguidorDer.get_collider().name.begins_with("Player")and !voyAtacar and !estoyMuriendo and !seguidorDer.get_collider().meMori():
		collisionShape.position.x = -4
		collision = CharacterController.Movimiento(1)
		AnimationController.CaminandoDerecha()
		AnimationController.flipContrario()
	elif seguidorIzq.is_colliding() and seguidorIzq.get_collider().name.begins_with("Player") and !voyAtacar and !estoyMuriendo and !seguidorIzq.get_collider().meMori():
		collisionShape.position.x = 3.2
		collision = CharacterController.Movimiento(-1)
		AnimationController.CaminandoIzquierda()
		AnimationController.flipContrario()	
	else:
		AnimationController.Normal()

	

func Atacar(ray):
	if ray.is_colliding() and ray.get_collider().name.begins_with("Player") and !estoyAtacando and !estoyMuriendo and !ray.get_collider().meMori():
		ray.enabled = false
		AnimationController.Ataque()
		Ataque(ray)
		


func golpie(ray):
	if ray.is_colliding() and ray.get_collider().name.begins_with("Player") and !estoyMuriendo:
		CharacterController.Golpie(ray.get_collider(),"Player",self)
		
func fuiGolpeado(golpeador):
	life.vida -= 1
	if life.vida > 0:
		var gravedadAnterior = CharacterController.gravedad
		collisionShape.disabled = true
		collisionShape.position.x += 1000
		CharacterController.gravedad = 0
		estoyMuriendo = true
		AnimationController.Golpeado()
		yield(get_tree().create_timer(0.5),"timeout")
		estoyMuriendo = false
		collisionShape.disabled = false
		collisionShape.position.x -= 1000
		AnimationController.animacion.play("Normal")
	else:
		CharacterController.gravedad = 0
		self.collisionShape.disabled = true
		collisionShape.position.x += 1000
		estoyMuriendo = true
		AnimationController.estoyMuriendo = true
		AnimationController.muerte()
		timer.start()
		GameManager.puntaje += puntaje
		
func Ataque(ray):
	voyAtacar = true
	estoyAtacando = true
	ray.enabled = true
	yield(get_tree().create_timer(0.6),"timeout")
	if !estoyMuriendo:
		golpie(ray)
	yield(get_tree().create_timer(0.6),"timeout")
	estoyAtacando = false
	voyAtacar = false		