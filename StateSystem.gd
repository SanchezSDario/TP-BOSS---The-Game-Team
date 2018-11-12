extends Node

var caster

func _ready():
	caster = get_parent()

func update_state():
	if(!caster.muerto):
		if(!caster.block):
			attack_state_handler()
	else: caster.state_identifier = "Death"

func attack_state_handler():
	if(!caster.attack):
		movement_state_handler()
	else: attack_state()

func movement_state_handler():
	if(!caster.meGolpiaron):
		idle_state()
		jump_state()
		walk_state()
	else: hit_state()

func idle_state(): 
	if(InputSystem.not_walking()): caster.state_identifier = "Idle"

func walk_state():
	jump_state()
	if(InputSystem.action_pressed("ui_left")):
		caster.state_identifier = "WalkLeft"
	if(InputSystem.action_pressed("ui_right")): 
		caster.state_identifier = "WalkRight"

func jump_state():
	if(InputSystem.action_pressed("ui_up")): caster.state_identifier = "Jump"

func attack_state():
	if(InputSystem.action_just_pressed("ui_attack")): caster.state_identifier = "Attack"

func hit_state():
	caster.state_identifier = "Hit"