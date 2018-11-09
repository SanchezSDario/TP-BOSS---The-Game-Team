extends KinematicBody2D
var movimiento = -10
var decremento = -2
var collision
var yaLepegue
var collisionShape
var fuiGolpeado
var primerGolpe = false
export var items = []
func _ready():
	collisionShape = get_node("CollisionShape2D")
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
	if !golpeador.sprite.flip_h:
		movimiento *= -1
	fuiGolpeado = true
	yield(get_tree().create_timer(0.5),"timeout")
	primerGolpe = true
		
func collision():
	if collision != null and collision.collider.name.begins_with("Tile") and primerGolpe:
		var scene_instance = dropItem()
		scene_instance = scene_instance.instance()
		scene_instance.set_name("Item")
		add_child(scene_instance)
		
		collisionShape.disabled = true
		set_process(false)
			
	if collision != null and collision.collider.name.begins_with("Player") and !yaLepegue:
		yaLepegue = true
		collision.collider.fuiGolpeado(self)
	if collision != null and collision.collider.name.begins_with("Enemy") :
		collision.collider.fuiGolpeado(self)
		
			
func dropItem():
	return items[0]		
		