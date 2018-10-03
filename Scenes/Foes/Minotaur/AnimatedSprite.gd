extends AnimatedSprite

var minotaur
var sprite_animation

func _ready():
	frames.set_animation_speed("Walk", 10)
	minotaur = get_parent()

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
		_: sprite_animation = "Idle"
