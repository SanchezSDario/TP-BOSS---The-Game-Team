extends KinematicBody2D

export var velocidadDeMovimiento = 0
var collision 
var sprite
var timer
var irALaIzquierda = true
export var soyBalaBoss = false
func _ready():
	sprite = get_node("Sprite")
	timer = Timer.new()
	timer.wait_time = 10
	timer.connect("timeout",self,"borrar")
	add_child(timer)
	timer.start()

	
	

func _process(delta):
	Movimiento()
	colisiones()
	
func borrar():
	self.queue_free()


		
func Movimiento():
	if irALaIzquierda:
		collision = move_and_collide(Vector2(-velocidadDeMovimiento,0.1))
		sprite.flip_h = true
		if soyBalaBoss:
			sprite.flip_h = false
	
	else:
		collision = move_and_collide(Vector2(velocidadDeMovimiento,0.1))
		sprite.flip_h = false
		if soyBalaBoss:
			sprite.flip_h = true
		
		

func colisiones():
	if collision != null and collision.collider.name.begins_with("Player"):
		collision.collider.fuiGolpeado(self)
		self.queue_free()
	elif collision != null :
		self.queue_free()
		
