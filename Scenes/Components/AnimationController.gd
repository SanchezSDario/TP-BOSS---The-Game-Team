extends Node2D

var animado
# necesita un nodo animationPlayer y su sprite
var animacion
var sprite 
var estoyAtacando
var estoyMuriendo
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
	if animacion.current_animation != "Normal" and animacion.current_animation != "Ataque" and animacion.current_animation != "Tirado" and animacion.current_animation != "Muerto" :
		animacion.play("Normal")
		

func Ataque():
	if animacion.current_animation != "Ataque":
		animacion.play("Ataque")
	
func Salto(estoyEnElAire):
	if animacion.current_animation != "Salto" and animacion.current_animation != "Ataque" and estoyEnElAire and animacion.current_animation != "Tirado" and animacion.current_animation != "Muerto":
		animacion.play("Salto")	

func Tirado(vida):
	if animacion.current_animation != "Tirado" and vida != 0:
		animacion.play("Tirado")
	elif animacion.current_animation != "Muerto" and vida == 0:
		animacion.play("Muerto")
		
func terminoAnimacion(animacionActual):
	return animacion.current_animation != animacionActual 
	
func flipContrario():
	if sprite.flip_h == true:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func Flip():
	return sprite.flip_h

func Stop():
	animacion.stop()