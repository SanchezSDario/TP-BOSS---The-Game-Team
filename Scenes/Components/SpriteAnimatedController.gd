extends Node2D

var animado
# necesita un nodo animationPlayer y su sprite
var animacion
var estoyMuriendo = false
var estoyAtacando
func _ready():
	
	animado = get_parent()
	animacion = get_node("AnimatedSprite")
	
	
	
func CaminandoDerecha():
	animacion.flip_h = false
	if animacion.animation != "Caminando" and !estoyMuriendo:
		animacion.play("Caminando")
	
func CaminandoIzquierda():
		animacion.flip_h = true
		if animacion.animation != "Caminando" and !estoyMuriendo :
			animacion.play("Caminando")
	
			
func Normal():
	if animacion.animation != "Normal" and animacion.animation != "Ataque" and animacion.animation != "Muerte" and animacion.animation != "Golpeado" and !estoyMuriendo:
		animacion.play("Normal")

func setFlip(flip):
	animacion.flip_h = flip
		
func Ataque():
	if animacion.animation != "Ataque" and !estoyMuriendo:
		animacion.play("Ataque")

func muerte():
	if animacion.animation != "Muerte" and estoyMuriendo:
		animacion.play("Muerte")

func Golpeado():
	if animacion.animation != "Golpeado":
		animacion.play("Golpeado")
		
func flipContrario():
	if animacion.flip_h == true:
		animacion.flip_h = false
	else:
		animacion.flip_h = true
	
func Flip():
	return animacion.flip_h
	