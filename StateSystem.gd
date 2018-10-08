extends Node

var caster

func _ready():
	caster = get_parent()

func update_state():
	idle_state()
	jump_state()
	walk_state()

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