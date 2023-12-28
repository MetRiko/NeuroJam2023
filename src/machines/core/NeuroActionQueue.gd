extends Node2D
class_name NeuroActionQueue


var action_tscn : PackedScene = preload("res://src/machines/core/NeuroAction.tscn")

var _actions : Array[NeuroAction] = []
var _prev_actions : Array[NeuroAction] = []

@export var stack_right : bool = true

@export var action_width = 128
@export var action_gap = 16


func add_message(msg_type: NeuroAction.Type) -> void:
	var action_inst : NeuroAction = action_tscn.instantiate()
	action_inst.message_type = msg_type
	_actions.push_back(action_inst)
	arrange_actions()


func dequeue_message():
	if len(_actions) <= 0:
		return null
	var msg : NeuroAction = _actions.pop_front()
	arrange_actions()
	return msg.message_type


func arrange_actions() -> void:
	var new_actions = []
	var removed_actions = []
	for action in _actions:
		if action not in _prev_actions:
			new_actions.append(action)
	for action in _prev_actions:
		if action not in _actions:
			removed_actions.append(action)

	for action in new_actions:
		add_child(action)
	
	for action in removed_actions:
		action.destroy()

	for i in range(len(_actions)):
		var action_pos = Vector2.RIGHT * (i + 1) * (action_width + action_gap) * (1 if stack_right else -1)
		_actions[i].update_pos(action_pos)

	_prev_actions.clear()
	_prev_actions.append_array(_actions)

