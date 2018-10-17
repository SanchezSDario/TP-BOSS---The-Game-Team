extends Node2D

export(float) var velocidadMovimiento = 0
export(float)  var salto = 0
export(float)  var gravedad = 0
var fuerzaSaltoRestante = 0
var character

var difGravity = 0
func _ready():
	character = get_parent()
func _process(delta):
	pass

func Gravedad():
	difGravity = gravedad - fuerzaSaltoRestante
	return character.move_and_collide(Vector2(0,difGravity))

func Golpie(target,tag,golpeador):
	if target.name.begins_with(tag):
		target.fuiGolpeado(golpeador)
	
func Movimiento(dir):
	return character.move_and_collide(Vector2(dir * velocidadMovimiento,0))
	
func Salto(puedoSaltar):
	if puedoSaltar:
		fuerzaSaltoRestante = salto

func Caer(delta):
	if fuerzaSaltoRestante > 0:
		fuerzaSaltoRestante -= (gravedad + salto)/2  * delta
		


