extends KinematicBody2D


var CharacterController
var AnimationController
func _ready():
	CharacterController = get_node("CharacterController")
	AnimationController = get_node("AnimationController")
	
	pass

func _process(delta):
	Movimientos()

func Movimientos():
	if Input.is_action_pressed("ui_right"):
		CharacterController.Movimiento(1)	
		AnimationController.CaminandoDerecha()
	elif Input.is_action_pressed("ui_left"):
		CharacterController.Movimiento(-1)	
		AnimationController.CaminandoIzquierda()
	else:
		AnimationController.Normal()
