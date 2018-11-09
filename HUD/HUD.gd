extends CanvasLayer

var vidas
var Personaje
var mostrarVida = false
func _ready():
	vidas = get_node("Sprite")
	yield(get_tree().create_timer(0.2),"timeout")
	Personaje = get_parent().get_node("Player")
	mostrarVida= true


	
func _process(delta):
	mostrarVidas()
	ubicarVidas()
	
func mostrarVidas():
	if mostrarVida  :
		vidas.play("Vida" + String(Personaje.vidas))


func ubicarVidas():
	vidas.position.x = get_viewport().size.x - 150
