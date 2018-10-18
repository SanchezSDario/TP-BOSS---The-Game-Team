extends CanvasLayer

var vidas

func _ready():
	vidas = get_node("Sprite")
	
func _process(delta):
	mostrarVidas()
	ubicarVidas()
	
func mostrarVidas():
	vidas.play("Vida" + String(GameManager.vidas))

func ubicarVidas():
	vidas.position.x = get_viewport().size.x - 150
