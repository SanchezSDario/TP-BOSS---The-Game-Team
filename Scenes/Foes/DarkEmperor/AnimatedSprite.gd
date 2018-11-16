extends AnimatedSprite

var emperor
var sprite_animation

func _ready():
	emperor = get_parent()
	frames.set_animation_speed("Idle", 8)
	frames.set_animation_speed("Run", 12)
	frames.set_animation_speed("Attack", 12)
	frames.set_animation_speed("Hit", 12)
	frames.set_animation_speed("Death", 2)
	frames.set_animation_loop("Attack", false)
	frames.set_animation_loop("Death", false)
	frames.set_animation_loop("Hit", false)
	play("Idle")

func _process(delta):
	if(!emperor.estoyMuriendo):
		select_animation()
		play(sprite_animation)
	else:
		play("Death")

func select_animation():
	match emperor.state_identifier:
		"WalkRight": 
			flip_h = false
			sprite_animation = "Run"
		"WalkLeft": 
			flip_h = true
			sprite_animation = "Run"
		"Jump": sprite_animation = "Jump"
		"Attack": sprite_animation ="Attack"
		"Hit": sprite_animation = "Hit"
		_: sprite_animation = "Idle"