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
var fuiGolpeado
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
	if (seguidorDer.is_colliding() and seguidorDer.get_collider() != null and
	    seguidorDer.get_collider().name.begins_with("Player")and !voyAtacar and
	    !estoyMuriendo and !seguidorDer.get_collider().meMori() and !fuiGolpeado):
		collision = CharacterController.Movimiento(1)
		state_identifier = "WalkRight"
		if(!$WalkSound.playing): $WalkSound.play()
	elif (seguidorIzq.is_colliding() and seguidorIzq.get_collider() != null and
	      seguidorIzq.get_collider().name.begins_with("Player") and !voyAtacar and
	      !estoyMuriendo and !seguidorIzq.get_collider().meMori() and ! fuiGolpeado):
		collision = CharacterController.Movimiento(-1)
		state_identifier = "WalkLeft"
		if(!$WalkSound.playing): $WalkSound.play()
	elif !estoyAtacando:
		if(fuiGolpeado): state_identifier = "Hit"
		else:
			if($WalkSound.playing): $WalkSound.stop()
			state_identifier = "Idle"

func collision():
	if self.collision != null and self.collision.collider.name.begins_with("Player"):
		collisionShape.disabled = true
	else:
		collisionShape.disabled = false

func Atacar(ray):
	if (ray.is_colliding() and ray.get_collider() != null and
	    ray.get_collider().name.begins_with("Player") and !estoyAtacando and
	    !estoyMuriendo and !ray.get_collider().meMori() and
	    !collisionShape.disabled and !voyAtacar and !fuiGolpeado):
		if($WalkSound.playing): $WalkSound.stop()
		voyAtacar = true
		ray.enabled = false
		if(!fuiGolpeado): Ataque(ray)

func golpie(ray):
	if (ray.is_colliding() and ray.get_collider() != null and
	    ray.get_collider().name.begins_with("Player") and !estoyMuriendo and
	    !collisionShape.disabled and !fuiGolpeado):
		CharacterController.Golpie(ray.get_collider(),"Player",self)

func fuiGolpeado(golpeador):
	$WalkSound.stop()
	fuiGolpeado = true
	$AttackRight.enabled = false
	$AttackLeft.enabled = false
	life.vida -= 1
	if life.vida > 0:
		$HitSound.play()
		$AnimatedSprite.position.y += 3
		var gravedadAnterior = CharacterController.gravedad
		collisionShape.disabled = true
		collisionShape.position.y += 1000
		CharacterController.gravedad = 0
		state_identifier = "Hit"
		yield(get_tree().create_timer(0.8),"timeout")
		estoyMuriendo = false
		$AttackRight.enabled = true
		$AttackLeft.enabled = true
		collisionShape.disabled = false
		collisionShape.position.y -= 1000
		state_identifier = "Idle"
		fuiGolpeado = false
		$AnimatedSprite.position.y -= 3
	else:
		$DeathSound.play()
		$WalkSound.stop()
		$SlashSound.stop()
		CharacterController.gravedad = 0
		self.collisionShape.disabled = true
		collisionShape.position.y += 1000
		estoyMuriendo = true
		state_identifier = "Death"
		timer.start()
		GameManager.puntaje += puntaje

func Ataque(ray):
	state_identifier = "Attack"
	estoyAtacando = true
	$AnimatedSprite.position.y -= 3.5
	ray.enabled = true
	yield(get_tree().create_timer(0.7),"timeout")
	if(!fuiGolpeado):
		$SlashSound.play()
		golpie(ray)
		$AnimatedSprite.position.y += 4
		state_identifier = "Idle"
		yield(get_tree().create_timer(0.5),"timeout")
		estoyAtacando = false
		voyAtacar = false
	else:
		$AnimatedSprite.position.y += 4
		yield(get_tree().create_timer(0.5),"timeout")
		estoyAtacando = false
		voyAtacar = false