extends Interactable
class_name Grabbable


@export var reset_position_on_grab := true

var reset_state := false
var _new_position: Vector2


func set_new_position(new_pos: Vector2) -> void:
	_new_position = new_pos
	reset_state = true


func _integrate_forces(state):
	if reset_state:
		state.transform.origin = _new_position
		reset_state = false

