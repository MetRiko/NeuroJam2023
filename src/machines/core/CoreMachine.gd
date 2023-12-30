extends Node2D


@export var chat_queue : NeuroActionQueue
@onready var _execute_action_timer : Timer = $ExecuteActionTimer


func _input(event):
    if event is InputEventKey and not event.echo and event.pressed:
        match event.keycode:
            KEY_1:
                var action := ChatLogic.NeuroPlannedAction.new()
                action.category = ChatLogic.NeuroActionCategory.IterestingStuff
                action.origin = ChatLogic.NeuroActionOrigin.Neuro
                add_planned_action(action)
            KEY_2:
                handle_planned_action()


func _ready():
    _execute_action_timer.timeout.connect(handle_planned_action)
    _execute_action_timer.start()


func add_planned_action(action: ChatLogic.NeuroPlannedAction) -> void:
    chat_queue.add_message(action)


func handle_planned_action() -> void:
    handle_action(chat_queue.dequeue_message())
    _execute_action_timer.start()


func destroy_chat_message() -> void:
    chat_queue.dequeue_message(true)
    _execute_action_timer.start()


func handle_action(action) -> void:
    if action != null:
        var response = Game.get_neuro_logic().generate_response(action)
        if response != null:
            print("Response: Category %s\nOrigin %s\nIntention %s\nContains bad words: %s\nOopsie: %s\nSchizo factor: %s\nTimeouted: %s\nTo Tutel: %s" % [
                ChatLogic.NeuroActionCategory.keys()[response.category],
                ChatLogic.NeuroActionOrigin.keys()[response.origin],
                response.intention,
                response.contains_bad_words,
                ChatLogic.NeuroActionOopsie.keys()[response.action_oopsie],
                response.schizo_factor,
                response.neuro_timeouted_someone,
                response.is_tutel_reciver
            ])
