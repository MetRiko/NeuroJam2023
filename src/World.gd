extends Node2D
class_name World

@export var chat_logic : ChatLogic
@export var neuro_logic : NeuroLogic
@export var viewership_logic : ViewershipLogic

func get_chat_logic() -> ChatLogic:
	return chat_logic

func get_neuro_logic() -> NeuroLogic:
	return neuro_logic

func get_viewership_logic() -> ViewershipLogic:
	return viewership_logic
