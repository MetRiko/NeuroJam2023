extends Node2D


@export var chat_queue : NeuroActionQueue
@onready var _execute_action_timer : Timer = $ExecuteActionTimer
@onready var _new_action_timer : Timer = $NewActionTimer

@export var execute_action_interval: float = 3.2

@export var new_action_interval: float = 3.2    # TODO: Make this dependent on viewer count?


func _input(event):
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_1:
                var action := NeuroLogic.NeuroPlannedAction.new()
                action.category = NeuroLogic.NeuroActionCategory.InterestingStuff
                action.origin = NeuroLogic.NeuroActionOrigin.Neuro
                add_planned_action(action)
            KEY_2:
                handle_planned_action()


func _ready():
    randomize()
    _execute_action_timer.timeout.connect(handle_planned_action)
    _execute_action_timer.start(execute_action_interval)

    _new_action_timer.timeout.connect(func(): add_random_planned_action(); _new_action_timer.start(new_action_interval))
    _new_action_timer.start(new_action_interval)

    add_hi_action()


func add_hi_action() -> void:
    var hi_action = NeuroLogic.NeuroPlannedAction.new()
    hi_action.origin = NeuroLogic.NeuroActionOrigin.Neuro
    hi_action.category = NeuroLogic.NeuroActionCategory.HiChat
    add_planned_action(hi_action)


func add_random_planned_action() -> void:
    var origin = randi() % len(NeuroLogic.NeuroActionOrigin.keys()) as NeuroLogic.NeuroActionOrigin

    var categories = [ 
        NeuroLogic.NeuroActionCategory.PogStuff, 
        NeuroLogic.NeuroActionCategory.AboutHerself, 
        NeuroLogic.NeuroActionCategory.InterestingStuff, 
        NeuroLogic.NeuroActionCategory.Joke, 
        NeuroLogic.NeuroActionCategory.Story, 
        NeuroLogic.NeuroActionCategory.CorpaMoment, 
        NeuroLogic.NeuroActionCategory.Question, 
        NeuroLogic.NeuroActionCategory.Answer
    ]
    var category = categories[randi() % len(categories)]

    var action = NeuroLogic.NeuroPlannedAction.new()
    action.origin = origin
    action.category = category
    add_planned_action(action)


func add_planned_action(action: NeuroLogic.NeuroPlannedAction) -> void:
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
                NeuroLogic.NeuroActionCategory.keys()[response.category],
                NeuroLogic.NeuroActionOrigin.keys()[response.origin],
                response.intention,
                response.contains_bad_words,
                NeuroLogic.NeuroActionOopsie.keys()[response.action_oopsie],
                response.schizo_factor,
                response.neuro_timeouted_someone,
                response.is_tutel_receiver
            ])
