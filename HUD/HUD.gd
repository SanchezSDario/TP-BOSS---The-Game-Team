extends CanvasLayer

var vidas
var Personaje
var mostrarVida = false
var powerUps
var animationPowerup
func _ready():
	vidas = get_node("Sprite")
	animationPowerup = get_node("AnimationPlayer")
	Personaje = get_parent()



	
func _process(delta):
	mostrarVidas()
	ubicarVidas()
	mostarPocionesPowerUp()
	
func mostrarVidas():
	vidas.play("Vida" + String(Personaje.vidas))


func mostarPocionesPowerUp():
	if  Personaje.Life.powerUp > 0:
		if animationPowerup.current_animation != "animar" + String(Personaje.Life.powerUp):
			animationPowerup.play("animar" + String(Personaje.Life.powerUp))
	else:
		animationPowerup.play("animar0")



func ubicarVidas():
	vidas.position.x = get_viewport().size.x - 150
