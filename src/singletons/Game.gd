extends Node

@onready var root = get_tree().root.get_node("Root")
@onready var world : World = root.get_node("World")

func get_neuro_logic() -> NeuroLogic:
	return world.get_neuro_logic()
	
func get_chat_logic() -> ChatLogic:
	return world.get_chat_logic()

func get_viewership_logic() -> ViewershipLogic:
	return world.get_viewership_logic()
