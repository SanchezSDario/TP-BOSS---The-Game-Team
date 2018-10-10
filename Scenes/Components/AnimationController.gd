extends Node2D

var animado
# necesita un nodo animationPlayer y su sprite
var animacion
var sprite 
var estoyAtacando
func _ready():
	animado = get_parent()
	animacion = get_node("AnimationPlayer")
	sprite = get_node("Sprite")
	
	
func CaminandoDerecha():
	sprite.flip_h = true
	if animacion.current_animation != "Caminando" :
		animacion.play("Caminando")
	
func CaminandoIzquierda():
		sprite.flip_h = false
		if animacion.current_animation != "Caminando" :
			animacion.play("Caminando")
	
			
func Normal():
	if animacion.current_animation != "Normal" and animacion.current_animation != "Ataque" :
		animacion.play("Normal")

func Ataque():
	if animacion.current_animation != "Ataque":
		animacion.play("Ataque")
	
func Salto():
	if animacion.current_animation != "Salto":
		animacion.play("Salto")	

	