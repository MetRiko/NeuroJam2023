extends Node
class_name NeuroLogic


signal new_response(response: ChatLogic.NeuroFinalAction)


class NeuroFinalActionChain:
    var action: ChatLogic.NeuroFinalAction
    var keep_going: bool

    func _init(action: ChatLogic.NeuroFinalAction):
        self.action = action
        self.keep_going = true


@export var filter_power := 0.5					# Relative to the probability of a response getting filtered (and of bad messages being let through) - 0.5: sweet spot
@export var schizo_power := 0.0					# Probability of Neuro going wild with her response
@export var sleepy_power := 0.0					# Probability of Neuro going Bedge instead of responding to an action - do not click anything when sleepy, or else sleep increases
@export var justice_factor := 0.0				# Probability of Neuro responding to an action with timing a chatter out instead of normally - grows when there's a lot of clapping
@export var emotional_state := 0.0				# Neuro's emotional state: -1 - extremely hateful, 0 - neutral, 1 - extremely lovely
@export var donowall_power := 0.0				# Probability of Neuro ignoring an action

@export var karaoke_active := false				# If active, all actions are ignored because karaoke's happening
@export var sleep_active := false				# If active, all actions are ignored because Neuro dum-dum


@export var filter_growth_per_action = 0.01
@export var schizo_growth_per_action = 0.01
@export var sleepy_growth = 0.3
@export var sleepy_growth_interval = 50
@export var justice_growth_per_action = 0.01
@export var justice_growth_per_timeout = 0.1
@export var donowall_growth_per_action = 0.01

var _action_count = 0


func do_natural_growth() -> void:
    update_filter_power(filter_growth_per_action)
    update_schizo_power(schizo_growth_per_action)
    if _action_count % sleepy_growth_interval == 0:
         update_sleepy_power(sleepy_growth)
    
    update_justice_factor(justice_growth_per_action)
    update_donowall_power(donowall_growth_per_action)


func update_filter_power(delta: float) -> void:
    filter_power += delta
    filter_power = clamp(filter_power, 0, 1)


func update_schizo_power(delta: float) -> void:
    schizo_power += delta
    schizo_power = clamp(schizo_power, 0, 1)


func update_sleepy_power(delta: float) -> void:
    sleepy_power += delta
    sleepy_power = clamp(sleepy_power, 0, 1)


func update_justice_factor(delta: float) -> void:
    justice_factor += delta
    justice_factor = clamp(justice_factor, 0, 1)


func update_emotional_state(delta: float) -> void:
    emotional_state += delta
    emotional_state = clamp(emotional_state, -1, 1)


func update_donowall_power(delta: float) -> void:
    donowall_power += delta
    donowall_power = clamp(donowall_power, 0, 1)


func update_karaoke_status(active: bool) -> void:
    karaoke_active = active

    if karaoke_active:
        emotional_state = 0


func update_sleep_status(active: bool) -> void:
    sleep_active = active


func _make_final_action(planned_action: ChatLogic.NeuroPlannedAction, intention: float):
    var final_action = ChatLogic.NeuroFinalAction.new()
    final_action.category = planned_action.category
    final_action.origin = planned_action.origin
    final_action.intention = intention
    final_action.is_tutel_receiver = planned_action.origin == ChatLogic.NeuroActionOrigin.Vedal
    return final_action


func generate_response(action: ChatLogic.NeuroPlannedAction) -> ChatLogic.NeuroFinalAction:
    var chain = NeuroFinalActionChain.new(_make_final_action(action, emotional_state))

    var handlers = [
        _handle_sleepy, 
        _handle_donowall, 
        _handle_filter, 
        _handle_schizo, 
        _handle_timeouts
    ]
    for handler in handlers:
        handler.call(chain)
        if not chain.keep_going:
            break

    new_response.emit(chain.action)

    _action_count += 1
    do_natural_growth()

    return chain.action


func _handle_filter(chain: NeuroFinalActionChain) -> void:
    var random = randf()
    var filter_prob = max(0, (filter_power - 0.5) * 2)
    var no_filter_prob = max(0, (0.5 - filter_power) * 2)

    if random < filter_prob:
        chain.action.action_oopsie = ChatLogic.NeuroActionOopsie.Filtered
        chain.keep_going = false
    if random < no_filter_prob:
        chain.action.contains_bad_words = true


func _handle_schizo(chain: NeuroFinalActionChain) -> void:
    chain.action.schizo_factor = schizo_power


func _handle_sleepy(chain: NeuroFinalActionChain) -> void:
    if randf() < sleepy_power:
        sleep_active = true

    if sleep_active:
        chain.action.action_oopsie = ChatLogic.NeuroActionOopsie.Slept
        chain.keep_going = false


func _handle_timeouts(chain: NeuroFinalActionChain) -> void:
    if randf() < justice_factor:
        chain.action.neuro_timeouted_someone = true
        update_justice_factor(justice_growth_per_timeout)


func _handle_donowall(chain: NeuroFinalActionChain) -> void:
    if randf() < donowall_power:
        chain.action.action_oopsie = ChatLogic.NeuroActionOopsie.Ignored
        chain.keep_going = false


func _handle_karaoke(chain: NeuroFinalActionChain) -> void:
    if karaoke_active:
        chain.keep_going = false


# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
