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
var puedoDisparar = true
export(PackedScene) var bala 
var caida
var areaAtaque 
export (PackedScene) var barriles
var ultimo = 0
var puedoPegarle = true
func _ready():
	areaAtaque =  get_node("Area2D")
	animationPlayer = get_node("AnimationPlayer")
	CharacterController = get_node("CharacterController")
	AnimatedSpriteController = get_node("AnimatedSpriteController")
	Life = get_node("Life")
	collisionShape = get_node("CollisionShape2D")
	sprite = get_node("AnimatedSpriteController/AnimatedSprite")
	set_process(false)
	yield(get_tree().create_timer(0.2),"timeout")
	player = get_parent().get_node("Player")
	

	
func _process(delta):
	contador += 1*delta
	secuenciaDeAtaques()
	caida = CharacterController.Gravedad()
	CharacterController.Caer(delta)
	miFLip()
	collisionConPersonaje()


func collisionConPersonaje():
	if caida != null and caida.collider.name.begins_with("Player") and puedoPegarle:
		caida.collider.fuiGolpeado(self)
		collisionShape.disabled = true
		puedoPegarle = false
	else:
		collisionShape.disabled = false

func secuenciaDeAtaques():
	if contador >= 0 and contador <= 1 :
		salto()
	if contador >= 1 and contador <= 3:
		Disparar()
	if contador >= 3 and contador <=4:
		salto()
	if contador >= 4 and contador <=7:
		Ataque()	
	if contador >= 7 and contador <= 8:
		salto()	
	if contador >= 8 and contador <=10	:
		caenBarriles()
	if contador > 10:
		contador = 0



func caenBarriles():
	if puedoDisparar:
		AnimatedSpriteController.Ataque2()
		ultimo += 1
		puedoDisparar = false
		yield(get_tree().create_timer(0.5),"timeout")
		var scene_instance = barriles
		scene_instance = scene_instance.instance()
		scene_instance.set_name("EnemyBarriles" + String(ultimo))
		get_parent().add_child(scene_instance)
		scene_instance.position.x = player.position.x - 100
		if self.sprite.flip_h:
			scene_instance.position.x += 50
		else: 
			scene_instance.position.x -= 50
		print(scene_instance.position)
		idle()
		puedoSaltar = true
		yield(get_tree().create_timer(5),"timeout")
		scene_instance.queue_free()

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
			scene_instance.position.x += 40
			scene_instance.irALaIzquierda = false
		else:
			scene_instance.position.x -= 40
		idle()
		puedoSaltar = true
			
			
func Ataque():
	if puedoDisparar:
		puedoPegarle = true
		puedoDisparar = false
		AnimatedSpriteController.Ataque()
		yield(get_tree().create_timer(0.5),"timeout")
		areaAtaque.position.y = areaAtaque.posYInicial	
		yield(get_tree().create_timer(1),"timeout")
		AnimatedSpriteController.animacion.play("Normal")
		areaAtaque.position.y -= 1000
		puedoSaltar = true
	
func miFLip():
	if player.position.x > self.position.x:
		self.sprite.flip_h = true
	else:
		self.sprite.flip_h = false		
		
func salto():
	AnimatedSpriteController.Salto()
	puedoDisparar = true
	CharacterController.Movimiento(((player.position - self.position  ).normalized()).x)
	CharacterController.SaltoEnemigo(puedoSaltar)
	puedoSaltar = false
		
	
	



func fuiGolpeado(golpeador):
	
	if Life.vida <= 0:
		self.queue_free()
	else:
		Life.vida -= 1
		animationPlayer.play("Golpeado")
		yield(get_tree().create_timer(0.2),"timeout")
		