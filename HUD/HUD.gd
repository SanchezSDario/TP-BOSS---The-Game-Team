extends CanvasLayer

var vidas

func _ready():
	vidas = get_node("Sprite")

func _process(delta):
	mostrarVidas()
	
func mostrarVidas():
	vidas.play("Vida" + String(GameManager.vidas))

