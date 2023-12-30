extends Node2D
class_name NeuroActionQueue


var action_tscn : PackedScene = preload("res://src/machines/core/NeuroAction.tscn")

var _actions : Array[NeuroAction] = []
var _prev_actions : Array[NeuroAction] = []

@export var stack_right : bool = true

@export var action_width = 128
@export var action_gap = 16


func size() -> int:
    return len(_actions)


func clear() -> void:
    _actions.clear()
    arrange_actions()


func add_message(action: NeuroLogic.NeuroPlannedAction) -> void:
    var action_inst: NeuroAction = action_tscn.instantiate()
    action_inst.action = action
    _actions.push_back(action_inst)
    arrange_actions()


func dequeue_message(offset: int = 0, destroy: bool = false):
    if len(_actions) <= 0 or offset >= len(_actions):
        return null
    var msg : NeuroAction = _actions[offset]
    _actions.pop_front()
    msg.to_be_destroyed = destroy
    arrange_actions()
    return msg.action


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
        action.execute()

    for i in range(len(_actions)):
        var action_pos = Vector2.RIGHT * i * (action_width + action_gap) * (1 if stack_right else -1)
        _actions[i].update_pos(action_pos)

    _prev_actions.clear()
    _prev_actions.append_array(_actions)

