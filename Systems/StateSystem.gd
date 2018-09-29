extends Node

func update_state(caster):
	idle_state(caster)
	walk_state(caster)

func idle_state(caster):
	if(InputSystem.not_walking()): caster.state_identifier = "Idle"

func walk_state(caster):
	if(InputSystem.action_pressed("ui_left")): 
		caster.state_identifier = "WalkLeft"
	if(InputSystem.action_pressed("ui_right")): 
		caster.state_identifier = "WalkRight"