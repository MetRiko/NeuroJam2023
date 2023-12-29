extends Node2D


@export var chat_queue : NeuroActionQueue
@onready var _execute_action_timer : Timer = $ExecuteActionTimer


signal new_message(msg_type: NeuroAction.Type)
signal say_message(msg_type: NeuroAction.Type)


func _input(event):
    if event is InputEventKey and not event.echo and event.pressed:
        match event.keycode:
            KEY_1:
                add_chat_message()
            KEY_2:
                handle_chat_message()


func _ready():
    _execute_action_timer.timeout.connect(handle_chat_message)
    _execute_action_timer.start()


func add_chat_message() -> void:
    var msg_type := NeuroAction.Type.SUB
    chat_queue.add_message(msg_type)
    new_message.emit(msg_type)


func handle_chat_message() -> void:
    handle_action(chat_queue.dequeue_message())
    _execute_action_timer.start()


func destroy_chat_message() -> void:
    chat_queue.dequeue_message(true)
    _execute_action_timer.start()


func handle_action(action_type) -> void:
    if action_type != null:
        say_message.emit(action_type)

        var response = Game.get_neuro_logic().generate_response(action_type)
        if response != null:
            print("Neuro: %s - %s" % [NeuroLogic.NeuroResponseType.keys()[response.type], response.content])
