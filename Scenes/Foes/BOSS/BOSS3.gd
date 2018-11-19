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
var audioAtaque
var audioAtaque2
var animacionMuerte
var gane
func _ready():

	audioAtaque = get_node("audioAtaqueFuego")
	audioAtaque2 = get_node("audioAtaqueFuego2")
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
	if !gane:
		secuenciaDeAtaques()
	caida = CharacterController.Gravedad()
	CharacterController.Caer(delta)
	miFLip()
	collisionConPersonaje()
	victoria()

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
	if contador >= 4 and contador <=6:
		Ataque()	
	if contador >= 6 and contador <= 7:
		salto()	
	if contador >= 7 and contador <=9	:
		caenBarriles()
	if contador > 8:
		contador = 0



func caenBarriles():
	if puedoDisparar:
		audioAtaque.play(0)
		AnimatedSpriteController.Ataque2()
		ultimo += 1
		puedoDisparar = false
		yield(get_tree().create_timer(0.5),"timeout")
		for i in range(0,5):
			var scene_instance = barriles
			scene_instance = scene_instance.instance()
			scene_instance.set_name("EnemyBarriles" + String(ultimo))
			get_parent().add_child(scene_instance)
			scene_instance.position.y = player.position.y - 300
			scene_instance.position.x = player.position.x + (i * 10)
		idle()
		puedoSaltar = true
		

func idle():
	AnimatedSpriteController.Normal()

func Disparar():
	if puedoDisparar:
		audioAtaque.play(0)
		AnimatedSpriteController.Ataque2()
		puedoDisparar = false
		yield(get_tree().create_timer(0.5),"timeout")
		var scene_instance = bala
		scene_instance = scene_instance.instance()
		scene_instance.set_name("Bala")
		add_child(scene_instance)
		if self.sprite.flip_h:
			scene_instance.position.x += 60
			scene_instance.position.y += 10
			scene_instance.irALaIzquierda = false
		else:
			scene_instance.position.x -= 60
			scene_instance.position.y += 10
		idle()
		puedoSaltar = true
			
			
func Ataque():
	if puedoDisparar:
		audioAtaque2.play(0)
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
		animationPlayer.play("Muerte")
		AnimatedSpriteController.animacion.visible = false
		self.collisionShape.disabled = true
		self.CharacterController.gravedad = 0
		self.collisionShape.position.y -= 1000
		yield(get_tree().create_timer(1),"timeout")
		self.visible = false
		player.set_process(false)
		gane = true
		yield(get_tree().create_timer(5),"timeout")
		get_tree().change_scene("res://Scenes/MenuDeEleccionDePersonajes/Selector.tscn")
	else:
		Life.vida -= 1
		animationPlayer.play("Golpeado")
		yield(get_tree().create_timer(0.2),"timeout")
		
func victoria():
	if gane:
		player.move_and_collide(Vector2(3,0))	
		player.AnimationController.CaminandoDerecha()	