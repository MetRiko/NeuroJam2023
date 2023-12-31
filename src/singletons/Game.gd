extends Node

@onready var root = get_tree().root.get_node("Root")
@onready var world : World = root.get_node("World")

signal do_reset
signal do_pause
signal do_start


func get_neuro_logic() -> NeuroLogic:
    return world.get_neuro_logic()
    

func get_chat_logic() -> ChatLogic:
    return world.get_chat_logic()


func get_ram_logic() -> RamLogic:
    return world.get_ram_logic()


func get_viewership_logic() -> ViewershipLogic:
    return world.get_viewership_logic()


func reset() -> void:
    print("--- RESETTING ---")
    do_reset.emit()


func pause() -> void:
    print("--- PAUSING ---")
    do_pause.emit()


func start() -> void:
    print("--- STARTING ---")
    do_start.emit()


func _ready():
   #  TODO: Remove this - for testing only
    AudioServer.set_bus_volume_db(0, -5.0)


func _input(event):
    if event is InputEventKey and not event.echo and event.pressed:
        match event.keycode:
            KEY_R:
                reset()
            KEY_S:
                start()
            KEY_P:
                pause()
