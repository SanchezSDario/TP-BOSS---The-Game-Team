extends AnimatedSprite

var minotaur
var sprite_animation

func _ready():
	minotaur = get_parent()
	frames.set_animation_speed("Idle", 12)
	frames.set_animation_speed("Walk", 12)
	frames.set_animation_speed("Attack", 12)
	frames.set_animation_speed("Hit", 12)
	frames.set_animation_speed("Death", 8)
	frames.set_animation_loop("Attack", false)
	frames.set_animation_loop("Death", false)
	frames.set_animation_loop("Hit", false)
	play("Idle")

func _process(delta):
	select_animation()
	play(sprite_animation)

func select_animation():
	match minotaur.state_identifier:
		"WalkRight": 
			flip_h = false
			sprite_animation = "Walk"
		"WalkLeft": 
			flip_h = true
			sprite_animation = "Walk"
		"Jump": sprite_animation = "Jump"
		"Attack": sprite_animation = "Attack"
		_: sprite_animation = "Idle"