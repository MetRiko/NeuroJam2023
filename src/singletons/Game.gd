extends Node

const lel = "asd"

@onready var root = get_tree().root.get_node("Root")


func get_neuro_logic() -> NeuroLogic:
	return root.get_node("World/Logic/NeuroLogic")
