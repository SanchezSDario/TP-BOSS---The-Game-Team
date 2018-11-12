extends KinematicBody2D

var CharacterController
var AnimatedSpriteController
var Life
var collisionShape
var sprite 
var animationPlayer
var player
var puedoSaltar = true
var contador = 0
var timer
var puedoDisparar = true
export(PackedScene) var bala 
var caida
func _ready():
	animationPlayer = get_node("AnimationPlayer")
	CharacterController = get_node("CharacterController")
	AnimatedSpriteController = get_node("AnimatedSpriteController")
	Life = get_node("Life")
	collisionShape = get_node("CollisionShape2D")
	sprite = get_node("AnimatedSpriteController/AnimatedSprite")
	set_process(false)
	yield(get_tree().create_timer(0.2),"timeout")
	player = get_parent().get_node("Player")
	timer = Timer.new()
	timer.wait_time = 0.5
	add_child(timer)
	timer.connect("timeout",self,"puedoDisparar")
	

func puedoDisparar():
	puedoDisparar = true
	
func _process(delta):
	contador += 1*delta
	secuenciaDeAtaques()
	caida = CharacterController.Gravedad()
	CharacterController.Caer(delta)
	miFLip()
	collisionConPersonaje()


func collisionConPersonaje():
	if caida != null and caida.collider.name.begins_with("Player"):
		collisionShape.disabled = true
	else:
		collisionShape.disabled = false

func secuenciaDeAtaques():
	if contador >= 0 and contador <= 1 :
		salto()
	if contador >= 1 and contador <= 2:
		Disparar()
	if contador >= 2 and contador <=3:
		salto()

func idle():
	AnimatedSpriteController.Normal()

func Disparar():
	if puedoDisparar:
		AnimatedSpriteController.Ataque2()
		puedoDisparar = false
		yield(get_tree().create_timer(0.5),"timeout")
		var scene_instance = bala
		scene_instance = scene_instance.instance()
		scene_instance.set_name("Bala")
		add_child(scene_instance)
		if self.sprite.flip_h:
			scene_instance.position.x += 20
			scene_instance.irALaIzquierda = false
		else:
			scene_instance.position.x -= 20
		idle()
		puedoSaltar = true
			
			
	
	
func miFLip():
	if player.position.x > self.position.x:
		self.sprite.flip_h = true
	else:
		self.sprite.flip_h = false		
		
func salto():
	
	CharacterController.Movimiento(((player.position - self.position  ).normalized()).x)
	CharacterController.Salto(puedoSaltar)
	puedoSaltar = false
		
	
	



func fuiGolpeado(golpeador):
	if Life.vida <= 0:
		self.queue_free()
	else:
		Life.vida -= 1
		animationPlayer.play("Golpeado")
		