extends Node2D

export var velocidadMovimiento = 0
export var salto = 0
export var gravedad = 0
var collision
var fuerzaSaltoRestante = 0
var character
var areaDeAtaque
var collisionAtaque
func _ready():
	character = get_parent()
	set_meta("Type","Player")
func _process(delta):
	pass

func Gravedad():
	collision =  character.move_and_collide(Vector2(0,gravedad - fuerzaSaltoRestante))
	return collision

func Golpie():
	print("UF")
	
func Movimiento(dir):
	collision = character.move_and_collide(Vector2(dir * velocidadMovimiento,0))
	return collision
	
func Salto(puedoSaltar):
	if puedoSaltar:
		fuerzaSaltoRestante = salto

func Caer(delta):
	if fuerzaSaltoRestante > 0:
		fuerzaSaltoRestante -= (gravedad + salto)/2  * delta
		


