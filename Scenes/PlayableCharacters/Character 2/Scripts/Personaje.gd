extends KinematicBody2D

signal jumpBuff
signal shootBuff
signal sumarPuntaje
export(int) var gravity
export(int)var basePropulse
var const_base_propulse
export(int) var movement
var arma= load("res://Scenes/PlayableCharacters/Character 2/ArmaHeroe.tscn")
var sprite
var buff

func _ready():
	const_base_propulse = basePropulse
	buff=false
	set_meta("Tipo", "Personaje")
	sprite=self.get_node("AnimatedSprite")
	sprite.play("Idle")
	sprite.frames.set_animation_loop("Jump", false)
	sprite.frames.set_animation_loop("Death", false)
 
func shoot():
	if Input.is_action_just_pressed("Shoot"):
		var proyectil= arma.instance()
		get_parent().shoot(proyectil)

func attack():
	if(Input.is_action_just_pressed("Shoot")):
		sprite.play("Attack")

func jump(deltis):
	if(Input.is_action_just_pressed("Jump")&& _notificar()):
		basePropulse = const_base_propulse 
		sprite.play("Jump")
	elif(basePropulse > 0 ):
		basePropulse -= (gravity + basePropulse) /2 * deltis

func chequeoDeColision():
	if (_notificar()!=null&& noSeMueve()):
		sprite.play("Idle")
func noSeMueve():
	return (!Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"))

func _move():
	if (Input.is_action_pressed("ui_right")):
		position.x +=movement
		sprite.flip_h=false
		moveAndJump()
	elif(Input.is_action_pressed("ui_left")):
		position.x -=movement
		sprite.flip_h=true
		moveAndJump()

func muero():
	gravity = 0
	$CollisionShape2D.disabled = true
	sprite.play("Muerte")
	yield(get_tree().create_timer(1.2),"timeout")
	queue_free()

func applyBuffs():
	emit_signal("shootBuff")

func _notificar():
	return move_and_collide(Vector2(0,gravity - basePropulse ))

func moveAndJump():
	if(Input.is_action_just_pressed("Jump")):
		sprite.play("Jump")
	elif(_notificar() != null):
		sprite.play("Walk")

func _process(delta):
	var collision= _notificar()
	_move()
	jump(delta)
	chequeoDeColision()
	attack()
	shoot()