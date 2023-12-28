extends Node

const lel = "asd"

@onready var world : World = get_node("/root/Root/World")

func get_chat_logic() -> ChatLogic:
	return world.get_chat_logic()
