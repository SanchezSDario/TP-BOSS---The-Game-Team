extends KinematicBody2D

var rayAtaqueIzq
var rayAtaqueDer
var CharacterController
var state_identifier
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
	rayAtaqueIzq = get_node("AttackLeft")
	rayAtaqueDer = get_node("AttackRight")
	seguidorDer = get_node("VissionRight")
	seguidorIzq = get_node("VissionLeft")
	CharacterController = get_node("CharacterController")
	collisionShape = get_node("CollisionShape2D")
	life = get_node("Life")

func _process(delta):
	if self.visible:
		seguidores()
		collision = CharacterController.Gravedad()
		Atacar(rayAtaqueDer)
		Atacar(rayAtaqueIzq)
		collision()

func borrar():
	self.queue_free()

func seguidores():
	if seguidorDer.is_colliding() and seguidorIzq.get_collider() != null and  seguidorDer.get_collider().name.begins_with("Player")and !voyAtacar and !estoyMuriendo and !seguidorDer.get_collider().meMori():
		collision = CharacterController.Movimiento(1)
		state_identifier = "WalkRight"
	elif seguidorIzq.is_colliding() and seguidorIzq.get_collider() != null and seguidorIzq.get_collider().name.begins_with("Player") and !voyAtacar and !estoyMuriendo and !seguidorIzq.get_collider().meMori():
		collision = CharacterController.Movimiento(-1)
		state_identifier = "WalkLeft"
	elif !estoyAtacando:
		state_identifier = "Idle"

func collision():
	if self.collision != null and self.collision.collider.name.begins_with("Player"):
		collisionShape.disabled = true
	else:
		collisionShape.disabled = false

func Atacar(ray):
	if ray.is_colliding() and ray.get_collider() != null and ray.get_collider().name.begins_with("Player") and !estoyAtacando and !estoyMuriendo and !ray.get_collider().meMori():
		voyAtacar = true
		ray.enabled = false
		Ataque(ray)

func golpie(ray):
	if ray.is_colliding()  and ray.get_collider() != null and ray.get_collider().name.begins_with("Player") and !estoyMuriendo and state_identifier != "Hit":
		CharacterController.Golpie(ray.get_collider(),"Player",self)

func fuiGolpeado(golpeador):
	life.vida -= 1
	print("UGH")
	if life.vida > 0:
		$AnimatedSprite.position.y += 3
		var gravedadAnterior = CharacterController.gravedad
		collisionShape.disabled = true
		collisionShape.position.x += 1000
		CharacterController.gravedad = 0
#		estoyMuriendo = true
		state_identifier = "Hit"
		yield(get_tree().create_timer(0.6),"timeout")
		estoyMuriendo = false
		collisionShape.disabled = false
		collisionShape.position.x -= 1000
		state_identifier = "Idle"
		$AnimatedSprite.position.y -= 3
	else:
		CharacterController.gravedad = 0
		self.collisionShape.disabled = true
		collisionShape.position.x += 1000
		estoyMuriendo = true
		state_identifier = "Death"
		timer.start()
		GameManager.puntaje += puntaje

func Ataque(ray):
	state_identifier = "Attack"
	estoyAtacando = true
	$AnimatedSprite.position.y -= 3.5
	ray.enabled = true
	yield(get_tree().create_timer(0.8),"timeout")
	golpie(ray)
	$AnimatedSprite.position.y += 3.5
	state_identifier = "Idle"
	yield(get_tree().create_timer(0.5),"timeout")
	estoyAtacando = false
	voyAtacar = false