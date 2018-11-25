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
var fuiGolpeado
var patternCounter = 0
export var puntaje = 0
var atemorize
var golpie

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
		patternCounter += 1*delta
		stabPattern()
		searchAndDestroyPattern()
		idle_pattern()
		reset()
		collision()

func stabPattern():
	if(stabbing_condition()): stab()
	else: atemorize = false

func searchAndDestroyPattern():
	if((patternCounter >= 2 and patternCounter <= 5) or
	   (patternCounter >= 8 and patternCounter <= 11) or
	   (patternCounter >= 14 and patternCounter <= 16)):
		searchAndDestroy()

func stabbing_condition():
	return ((patternCounter >= 0 and patternCounter <= 2) or
	        (patternCounter >= 6 and patternCounter <= 8) or
	        (patternCounter >= 12 and patternCounter <= 14))

func idle_pattern():
	if((patternCounter >=5 and patternCounter <= 6) or
	   (patternCounter >= 11 and patternCounter <= 12) or
	   (patternCounter >= 16 and patternCounter <= 15)):
		state_identifier = "Idle"
		pass

func reset():
	if(patternCounter > 15): patternCounter = 0

func searchAndDestroy():
		seguidores()
		Atacar(rayAtaqueDer)
		Atacar(rayAtaqueIzq)
		collision()

func stab():
	stabbing()
	collision()

func stabbing():
	if (seguidorDer.is_colliding() and seguidorIzq.get_collider() != null and 
	    seguidorDer.get_collider().name.begins_with("Player") and
	    !voyAtacar and !estoyMuriendo and !seguidorDer.get_collider().meMori()):
			if(!atemorize):
				atemorize = true
				$StabShout.play()
			stab_right()
	elif (seguidorIzq.is_colliding() and
	    seguidorIzq.get_collider() != null and 
		seguidorIzq.get_collider().name.begins_with("Player")and
		!voyAtacar and !estoyMuriendo and !seguidorIzq.get_collider().meMori()):
			if(!atemorize):
				atemorize = true
				$StabShout.play()
			stab_left()
	else:
		if(atemorize and !golpie): state_identifier = "Walk"
		else: state_identifier = "Idle"

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
	if (ray.is_colliding() and ray.get_collider() != null and
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
	if(golpie):
		yield(get_tree().create_timer(1),"timeout")
		golpie = false
	yield(get_tree().create_timer(0.5),"timeout")
	stabbing = false
	estoyAtacando = false
	voyAtacar = false

func borrar():
	self.queue_free()

func seguidores():
	if (seguidorDer.is_colliding() and seguidorDer.get_collider() != null and
	    seguidorDer.get_collider().name.begins_with("Player") and
	    !voyAtacar and !estoyMuriendo and !seguidorDer.get_collider().meMori()):
		collision = CharacterController.Movimiento(1)
		state_identifier = "WalkRight"
	elif (seguidorIzq.is_colliding() and seguidorIzq.get_collider() != null and
	      seguidorIzq.get_collider().name.begins_with("Player") and
	      !voyAtacar and !estoyMuriendo and !seguidorIzq.get_collider().meMori()):
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
	if (ray.is_colliding() and ray.get_collider() != null and
	    ray.get_collider().name.begins_with("Player") and
	    !estoyAtacando and !estoyMuriendo and !ray.get_collider().meMori()):
		voyAtacar = true
		ray.enabled = false
		state_identifier = "Attack"
		Ataque(ray)

func golpie(ray):
	if (ray.is_colliding() and ray.get_collider() != null and
	    ray.get_collider().name.begins_with("Player") and !estoyMuriendo):
		if(stabbing_condition()): $StabHit.play()
		golpie = true
		CharacterController.Golpie(ray.get_collider(),"Player",self)

func fuiGolpeado(golpeador):
	life.vida -= 1
	fuiGolpeado = true
	if life.vida > 0:
		var gravedadAnterior = CharacterController.gravedad
		collisionShape.disabled = true
		collisionShape.position.x += 1000
		CharacterController.gravedad = 0
		yield(get_tree().create_timer(0.6),"timeout")
		estoyMuriendo = false
		fuiGolpeado = false
		collisionShape.disabled = false
		collisionShape.position.x -= 1000
		state_identifier = "Idle"
	else:
		$StabShout.stop()
		$Death.play()
		CharacterController.gravedad = 0
		self.collisionShape.disabled = true
		collisionShape.position.x += 1000
		estoyMuriendo = true
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
		position.y += 10
		state_identifier = "Death"
		timer.start()
		yield(get_tree().create_timer(5),"timeout")
		get_tree().change_scene("res://Scenes/MenuDeEleccionDePersonajes/Selector.tscn")
		GameManager.puntaje += puntaje

func Ataque(ray):
	estoyAtacando = true
	ray.enabled = true
	yield(get_tree().create_timer(0.6),"timeout")
	$Slash.play()
	golpie(ray)
	if(golpie):
		yield(get_tree().create_timer(1),"timeout")
		golpie = false
	yield(get_tree().create_timer(0.5),"timeout")
	estoyAtacando = false
	voyAtacar = false