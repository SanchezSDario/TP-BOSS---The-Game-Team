extends AnimatedSprite

var assasin
var sprite_animation

func _ready():
	assasin = get_parent()

func _process(delta):
	select_animation()
	play(sprite_animation)

func select_animation():
	match assasin.state_identifier:
		"WalkRight": 
			flip_h = false
			sprite_animation = "Walk"
		"WalkLeft": 
			flip_h = true
			sprite_animation = "Walk"
		_: sprite_animation = "Idle"