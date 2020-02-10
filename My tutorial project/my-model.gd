extends Spatial

const locomotion_state := {
	'idle' : Vector2(0,0),
	'walk' : Vector2(0,1),
	'run' : Vector2(1,0)
}

const jump_types := {
	'idle' : 0,
	'run' : 1
}
onready var animator = $AnimationPlayer/AnimationTree
const TRANSITION_SPEED = 2

var last_animation
var transition_state := 0.0

func _process(delta):
	var target = null
	var jump_target = null
	if Input.is_action_pressed("walk"):
		target = locomotion_state.walk
		if Input.is_action_pressed("run"):
			target = locomotion_state.run
	else :
		target = locomotion_state.idle
	
	if Input.is_action_pressed("jump"):
		jump_target = jump_types.idle if target == locomotion_state.idle else jump_types.run
		animator['parameters/jump-type/current'] = jump_target
		animator['parameters/jump/active'] = true
	
	if jump_target == null:
		transition_state += delta * TRANSITION_SPEED
		if transition_state > 1:
			transition_state = 1
		
		if last_animation != target:
			transition_state = 0
		
		animator['parameters/locomotion/blend_position'] = animator['parameters/locomotion/blend_position'].linear_interpolate(target, transition_state)
		last_animation = target
