extends KinematicBody2D
var movimiento = -10
var decremento = -2
var collision
var yaLepegue
var collisionShape
var fuiGolpeado
var primerGolpe = false
export var items = []
enum itemsAElegir{pocion,powerup,esqueleto}
export(itemsAElegir) var itemElegido
var sprite
func _ready():
	collisionShape = get_node("CollisionShape2D")
	sprite = get_node("Sprite")
	#self.collisionShape.disabled = true
	
	

func _process(delta):
	Animacion(delta)
	collision()

	
func Animacion(delta):	
	if fuiGolpeado:
		decremento += 2.8 * delta
		collision = self.move_and_collide (5 *Vector2(sin(movimiento),decremento))
		self.rotation += 2*delta
	

func fuiGolpeado(golpeador):
	if !fuiGolpeado:
		var scene_instance = dropItem()
		scene_instance = scene_instance.instance()
		get_parent().add_child(scene_instance)
		scene_instance.set_name("Enemy")
		scene_instance.position = posicion()
	if !golpeador.sprite.flip_h:
		movimiento *= -1
	fuiGolpeado = true
	yield(get_tree().create_timer(0.5),"timeout")
	primerGolpe = true
		
func collision():
	if collision != null and collision.collider.name.begins_with("Tile") and primerGolpe:
		collisionShape.disabled = true
		set_process(false)
	if collision != null and collision.collider.name.begins_with("Player") and !yaLepegue:
		yaLepegue = true
		collision.collider.fuiGolpeado(self)
	if collision != null and collision.collider.name.begins_with("Enemy") :
		collision.collider.fuiGolpeado(self)
		
			
func dropItem():
	return items[itemElegido]		
	
func posicion():
	if itemElegido == itemsAElegir.esqueleto:
		return Vector2(self.position.x,self.position.y -10)
	else:
		return Vector2(self.position.x,self.position.y +10)
		