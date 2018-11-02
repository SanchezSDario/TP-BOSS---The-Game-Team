extends Node2D

var area
var bicho
export var cantidad = 0

func _ready():
	bicho = get_node("EnemyEsqueleto")
	area = get_node("Area2D")
	area.connect("body_exited",self,"ponerEsqueleto") 
	bicho.collisionShape.disabled = true
	bicho.CharacterController.gravedad = 0

func ponerEsqueleto(target):
	bicho.visible = true
	bicho.CharacterController.gravedad = 10
	area.queue_free()


