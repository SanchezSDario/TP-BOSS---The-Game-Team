extends KinematicBody2D

var CharacterController
var AnimatedSpriteController
var Life
var collisionShape
var sprite 
var animationPlayer
var timer
var player
var puedoSaltar = true
func _ready():

	CharacterController = get_node("CharacterController")
	AnimatedSpriteController = get_node("AnimatedSpriteController")
	Life = get_node("Life")
	collisionShape = get_node("CollisionShape2D")
	sprite = get_node("AnimatedSpriteController/AnimatedSprite")
	animationPlayer = get_node("AnimationPlayer")
	timer = Timer.new()
	timer.wait_time = 2
	add_child(timer)
	timer.connect("timeout",self,"proximoAtaque")
	set_process(false)
	yield(get_tree().create_timer(0.2),"timeout")
	player = get_parent().get_node("Player")
	

func _process(delta):
	saltoDer()
	CharacterController.Gravedad()
	CharacterController.Caer(delta)

func proximoAtaque():
	print("PROXIMO")


func saltoDer():
	CharacterController.Movimiento(((player.position - self.position  ).normalized()).x)
	CharacterController.Salto(puedoSaltar)
	puedoSaltar = false
		
	
	

func start():
	timer.start()

func fuiGolpeado(golpeador):
	if Life.vida <= 0:
		self.queue_free()
	else:
		Life.vida -= 1
		animationPlayer.play("Golpeado")
		