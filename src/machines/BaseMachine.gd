extends Node2D
class_name BaseMachine


@export var machine_active: bool = false


func activate_machine() -> void:
    machine_active = true
    

func deactivate_machine() -> void:
    machine_active = false
