extends Node

@onready var root = get_tree().root.get_node("Root")
@onready var world : World = root.get_node("World")

signal do_reset

func get_neuro_logic() -> NeuroLogic:
    return world.get_neuro_logic()
    
func get_chat_logic() -> ChatLogic:
    return world.get_chat_logic()

func get_viewership_logic() -> ViewershipLogic:
    return world.get_viewership_logic()

func reset() -> void:
    get_neuro_logic().reset()

    do_reset.emit()


func _ready():
    # TODO: Remove this - for testing only
    AudioServer.set_bus_volume_db(0, -10.0)


func _input(event):
    if event is InputEventKey:
        if event.keycode == KEY_R and not event.echo and event.pressed:
            reset()
