extends BaseMachine
class_name CoreMachine


@export var chat_queue : NeuroActionQueue
@onready var _execute_action_timer : Timer = $ExecuteActionTimer
@onready var _new_action_timer : Timer = $NewActionTimer

@export var execute_action_interval: float = 2.2
@export var execute_action_variance: float = 0.0#0.5

var new_action_interval: float = 0.1 #3.2
var new_action_variance: float = 0.0 #0.5

@export var planned_action_limit: int = 20

@export var dono_action_time_multiplier: float = 0.8
@export var vedal_action_time_multiplier: float = 1.7
@export var bomb_action_time_multiplier: float = 2.6

var execute_action_speedup: float = 1.02
var new_action_speedup: float = 1.02

var _actual_execute_action_interval: float
var _actual_new_action_interval: float

static var ref : CoreMachine = null

static func get_machine() -> CoreMachine:
    return ref

func _init():
    ref = self

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
    _new_action_timer.timeout.connect(handle_new_action)

    Game.do_reset.connect(reset)
    Game.do_pause.connect(pause)
    Game.do_start.connect(start)

    reset()


func handle_new_action():
    if machine_active:
        add_random_planned_action()
        _new_action_timer.start(_actual_new_action_interval)


func reset_intervals() -> void:
    _actual_execute_action_interval = execute_action_interval
    _actual_new_action_interval = new_action_interval


func pause() -> void:
    deactivate_machine()


func start() -> void:
    activate_machine()


func reset() -> void:
    chat_queue.clear()

    reset_intervals()

    _execute_action_timer.start(_actual_execute_action_interval + randf_range(-1, 1) * execute_action_variance)
    _new_action_timer.start(_actual_new_action_interval + randf_range(-1, 1) * new_action_variance)

    add_hi_action()
    add_hi_action()


func add_hi_action() -> void:
    var hi_action = NeuroLogic.NeuroPlannedAction.new()
    hi_action.origin = NeuroLogic.NeuroActionOrigin.Chat
    hi_action.category = NeuroLogic.NeuroActionCategory.HiChat
    add_planned_action(hi_action)


func add_random_planned_action() -> void:
    add_planned_action(Game.get_neuro_logic().plan_random_action())


func add_planned_action(action: NeuroLogic.NeuroPlannedAction) -> void:
    if chat_queue.size() < planned_action_limit:
        chat_queue.add_message(action)


func handle_planned_action() -> void:
    if machine_active:
        handle_action(chat_queue.dequeue_message(1))
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
        
        _actual_execute_action_interval /= execute_action_speedup
        _actual_new_action_interval /= new_action_speedup

        _actual_execute_action_interval = max(_actual_execute_action_interval, 0.05)
        _actual_new_action_interval = max(_actual_new_action_interval, 0.04)

        var time = _actual_execute_action_interval + randf_range(-1, 1) * execute_action_variance
        match action.origin:
            NeuroLogic.NeuroActionOrigin.Donation:
                time *= dono_action_time_multiplier
            NeuroLogic.NeuroActionOrigin.Bomb:
                time *= bomb_action_time_multiplier
            NeuroLogic.NeuroActionOrigin.Vedal:
                time *= vedal_action_time_multiplier
        _execute_action_timer.start(time)
