extends AnimatedSprite

var assasin
var sprite_animation

func _ready():
	frames.set_animation_loop("Jump", false)
	frames.set_animation_speed("Jump", 10)
	frames.set_animation_speed("Walk", 10)
	frames.set_animation_loop("Attack", false)
	frames.set_animation_speed("Attack", 10)
	frames.set_animation_loop("Hit", false)
	frames.set_animation_speed("Hit", 10)
	frames.set_animation_loop("Block", false)
	frames.set_animation_speed("Block", 10)
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
		"Jump": sprite_animation = "Jump"
		"Attack": 
			get_parent().position.y -= 3
			sprite_animation = "Attack"
		"Block": sprite_animation = "Block"
		"Hit": sprite_animation = "Hit"
		_: sprite_animation = "Idle"