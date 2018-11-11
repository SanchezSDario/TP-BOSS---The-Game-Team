extends CanvasLayer

var vidas
var Personaje
var mostrarVida = false
var powerUps
var animationPowerup
func _ready():
	vidas = get_node("Sprite")
	animationPowerup = get_node("AnimationPlayer")
	yield(get_tree().create_timer(0.2),"timeout")
	Personaje = get_parent().get_node("Player")
	mostrarVida= true


	
func _process(delta):
	mostrarVidas()
	ubicarVidas()
	mostarPocionesPowerUp()
	
func mostrarVidas():
	if mostrarVida  :
		vidas.play("Vida" + String(Personaje.vidas))


func mostarPocionesPowerUp():
	if mostrarVida and Personaje.Life.powerUp > 0:
		if animationPowerup.current_animation != "animar" + String(Personaje.Life.powerUp):
			animationPowerup.play("animar" + String(Personaje.Life.powerUp))
	else:
		animationPowerup.play("animar0")



func ubicarVidas():
	vidas.position.x = get_viewport().size.x - 150
