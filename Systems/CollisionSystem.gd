extends Node

func execute(caster):
	if(caster.collision != null):
		match caster.collision.collider.get_meta("Type"):
			"Floor": caster.jump = false