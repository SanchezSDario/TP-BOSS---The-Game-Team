extends KinematicBody2D

var rayAtaqueIzq
var rayAtaqueDer
var CharacterController
var state_identifier
var collisionShape
var seguidorDer
var seguidorIzq
var collision
var stabbing
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
	collision = CharacterController.Gravedad()
	if self.visible:
		stab()
#		searchAndDestroy()


func searchAndDestroy():
		seguidores()
		Atacar(rayAtaqueDer)
		Atacar(rayAtaqueIzq)
		collision()

func stab():
	stabbing()
	collision()

func stabbing():
	if (seguidorDer.is_colliding() and
	    seguidorIzq.get_collider() != null and 
		seguidorDer.get_collider().name.begins_with("Player")and
		!voyAtacar and !estoyMuriendo and !seguidorDer.get_collider().meMori()):
			stab_right()
	if (seguidorIzq.is_colliding() and
	    seguidorIzq.get_collider() != null and 
		seguidorIzq.get_collider().name.begins_with("Player")and
		!voyAtacar and !estoyMuriendo and !seguidorIzq.get_collider().meMori()):
			stab_left()
	elif(!stabbing): state_identifier = "Idle"

func stab_right():
	stabbing = true
	state_identifier = "StabRight"
	yield(get_tree().create_timer(0.6),"timeout")
	collision = CharacterController.Movimiento(3)
	stab_damage($AttackRight)

func stab_left():
	stabbing = true
	state_identifier = "StabLeft"
	yield(get_tree().create_timer(0.6),"timeout")
	collision = CharacterController.Movimiento(-3)
	stab_damage($AttackLeft)

func stab_damage(ray):
	if (ray.is_colliding() and
	    ray.get_collider() != null and
	    ray.get_collider().name.begins_with("Player") and
	    !estoyAtacando and !estoyMuriendo and !ray.get_collider().meMori()):
		voyAtacar = true
		ray.enabled = false
		stab_attack(ray)

func stab_attack(ray):
	estoyAtacando = true
	ray.enabled = true
	yield(get_tree().create_timer(0.2),"timeout")
	golpie(ray)
	state_identifier = "Idle"
	yield(get_tree().create_timer(0.5),"timeout")
	stabbing = false
	estoyAtacando = false
	voyAtacar = false

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
	if (ray.is_colliding() and
	    ray.get_collider() != null and
	    ray.get_collider().name.begins_with("Player") and
	    !estoyAtacando and !estoyMuriendo and !ray.get_collider().meMori()):
		voyAtacar = true
		ray.enabled = false
		state_identifier = "Attack"
		Ataque(ray)

func golpie(ray):
	if ray.is_colliding()  and ray.get_collider() != null and ray.get_collider().name.begins_with("Player") and !estoyMuriendo:
		CharacterController.Golpie(ray.get_collider(),"Player",self)

func fuiGolpeado(golpeador):
	life.vida -= 1
	print("UGH")
	if life.vida > 0:
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
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
		position.y += 13
		state_identifier = "Death"
		timer.start()
		GameManager.puntaje += puntaje

func Ataque(ray):
	estoyAtacando = true
	ray.enabled = true
	yield(get_tree().create_timer(0.6),"timeout")
	golpie(ray)
	state_identifier = "Idle"
	yield(get_tree().create_timer(0.5),"timeout")
	estoyAtacando = false
	voyAtacar = false