extends Node2D

var animado
# necesita un nodo animationPlayer y su sprite
var animacion

var estoyAtacando
func _ready():
	
	animado = get_parent()
	animacion = get_node("AnimatedSprite")
	
	
	
func CaminandoDerecha():
	animacion.flip_h = true
	if animacion.animation != "Caminando":
		animacion.play("Caminando")
	
func CaminandoIzquierda():
		animacion.flip_h = false
		if animacion.animation != "Caminando" :
			animacion.play("Caminando")
	
			
func Normal():
	if animacion.animation != "Normal" and animacion.animation != "Ataque" and animacion.animation != "Caminando" :
		animacion.play("Normal")

func Ataque():
	if animacion.animation != "Ataque":
		animacion.play("Ataque")
		
func flipContrario():
	if animacion.flip_h == true:
		animacion.flip_h = false
	else:
		animacion.flip_h = true
	
func Flip():
	return animacion.flip_h
	