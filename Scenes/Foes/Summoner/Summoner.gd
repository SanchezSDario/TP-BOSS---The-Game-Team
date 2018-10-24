extends KinematicBody2D

var collisionShape
var life
var AnimationController
var CharacterController
var rayAtaqueDer
var rayAtaqueIzq
var voyAtacar = false
var estoyMuriendo = false
var timer
var esqueleto
var siguiente = 0
export var puntaje = 0
func _ready():
	timer = Timer.new()
	timer.wait_time = 15
	timer.connect("timeout",self,"borrar")
	add_child(timer)
	collisionShape = get_node("CollisionShape2D")
	life = get_node("Life")
	AnimationController = get_node("AnimatedSpriteController")
	CharacterController = get_node("CharacterController")
	rayAtaqueDer = get_node("rayAtaqueDer")
	rayAtaqueIzq = get_node("rayAtaqueIzq")


func _process(delta):
	seguidores()
	
func borrar():
	self.queue_free()
		
	
func seguidores():
	if rayAtaqueDer.is_colliding() and rayAtaqueDer.get_collider().name.begins_with("Player")and !voyAtacar and !estoyMuriendo and !rayAtaqueDer.get_collider().meMori():
		AnimationController.setFlip(true)
		Ataque()
	elif rayAtaqueIzq.is_colliding() and rayAtaqueIzq.get_collider().name.begins_with("Player") and !voyAtacar and !estoyMuriendo and !rayAtaqueIzq.get_collider().meMori():
		AnimationController.setFlip(false)
		Ataque()
	elif !voyAtacar:
		AnimationController.Normal()
		
func Ataque():
	if siguiente <= 8:
		voyAtacar = true
		siguiente += 1
		AnimationController.Ataque()
		yield(get_tree().create_timer(1),"timeout")
  ### poner bicho
		esqueleto = get_node("EnemyEsquletoVerde" + String(siguiente))
		esqueleto.visible = true 
		esqueleto.collisionShape.disabled = false
	if !estoyMuriendo:
		AnimationController.animacion.play("Normal")
	yield(get_tree().create_timer(2),"timeout")
	voyAtacar = false
		
		
func fuiGolpeado(golpeador):
	life.vida -= 1
	if life.vida > 0:
		var gravedadAnterior = CharacterController.gravedad
		collisionShape.disabled = true
		collisionShape.position.x += 1000
		CharacterController.gravedad = 0
		estoyMuriendo = true
		AnimationController.Golpeado()
		yield(get_tree().create_timer(0.6),"timeout")
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

