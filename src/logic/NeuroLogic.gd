extends Node
class_name NeuroLogic


enum NeuroActionOrigin {
    Neuro, Chat, Vedal, Donation, Bomb
}

enum NeuroActionCategory {
    None, PogStuff, AboutHerself, InterestingStuff, Joke, Story, CorpaMoment, Question, Answer, HiChat
}

enum NeuroActionOopsie {
    None, Filtered, Ignored
}

class NeuroPlannedAction:
    var origin : NeuroActionOrigin # Neuro, Chat, Vedal, Donation
    var category : NeuroActionCategory # PogStuff, AboutHerself, InterestingStuff, Joke, Story, CorpaMoment, Question, Answer

class NeuroFinalAction extends NeuroPlannedAction:
    # var message : String # will be getter, depends on category
    var intention : float  # evil, neutral, love   -1.0..1.0
    var contains_bad_words : bool
    var action_oopsie : NeuroActionOopsie
    var schizo_factor : float
    var neuro_timeouted_someone : bool
    var is_tutel_receiver : bool


signal neuro_action_started(neuro_action: NeuroFinalAction)
signal karaoke_status_changed(karaoke_active: bool)
signal sleep_status_changed(sleep_active: bool)
signal donowall_status_changed(donowall_active: bool)


class NeuroFinalActionChain:
    var action: NeuroFinalAction
    var keep_going: bool

    func _init(action: NeuroFinalAction):
        self.action = action
        self.keep_going = true


@export var filter_power := 0.0					# Relative to the probability of a response getting filtered (and of bad messages being let through) - 0: sweet spot
@export var schizo_power := 0.0					# Probability of Neuro going wild with her response
@export var sleepy_power := 0.0					# Probability of Neuro going Bedge instead of responding to an action - do not click anything when sleepy, or else sleep increases
@export var justice_factor := 0.0				# Probability of Neuro responding to an action with timing a chatter out instead of normally - grows when there's a lot of clapping
@export var emotional_state := 0.0				# Neuro's emotional state: -1 - extremely hateful, 0 - neutral, 1 - extremely lovely

@export var karaoke_active := false				# If active, all actions are ignored because karaoke's happening
@export var sleep_active := false				# If active, all actions are ignored because Neuro Bedge
@export var donowall_active := false		    # If active, all actions are ignored because Neuro dum-dum
@export var timeout_block_active := false		# If active, Neuro cannot time out

var prev_action_was_bomb := false
var prev_action_had_cookie := false

var latest_bomb_defused_successfully := false

@export var filter_growth_per_action = 0.01
@export var schizo_growth_per_action = 0.01
@export var sleepy_growth = 0.3
@export var sleepy_growth_interval = 50

@export var emotional_state_variance_multiplier = 1.1
@export var emotional_state_random_area = 0.3
@export var emotional_state_random_amount = 0.2

@export var justice_factor_variance_frequency = 0.01

var _action_count = 0
var _has_vedal_appeared := false

@export var origin_weights: Dictionary = {
    NeuroActionOrigin.Neuro: 5, 
    NeuroActionOrigin.Chat: 4, 
    NeuroActionOrigin.Vedal: 3, 
    NeuroActionOrigin.Donation: 3, 
    NeuroActionOrigin.Bomb: 1
}

@export var category_weights: Dictionary = {
    NeuroActionCategory.PogStuff: 1, 
    NeuroActionCategory.AboutHerself: 1, 
    NeuroActionCategory.InterestingStuff: 1, 
    NeuroActionCategory.Joke: 1, 
    NeuroActionCategory.Story: 1, 
    NeuroActionCategory.CorpaMoment: 1, 
    NeuroActionCategory.Question: 1, 
    NeuroActionCategory.Answer: 1,
}

var _categories_by_origin: Dictionary = {
    NeuroActionOrigin.Neuro: [
        NeuroActionCategory.Joke, 
        NeuroActionCategory.Story,
        NeuroActionCategory.PogStuff, 
        NeuroActionCategory.AboutHerself, 
        NeuroActionCategory.InterestingStuff, 
        NeuroActionCategory.CorpaMoment, 
    ],
    NeuroActionOrigin.Chat: [
        NeuroActionCategory.Question,
        NeuroActionCategory.Answer,
        NeuroActionCategory.PogStuff, 
        NeuroActionCategory.AboutHerself, 
        NeuroActionCategory.InterestingStuff, 
        NeuroActionCategory.CorpaMoment, 
    ],
    NeuroActionOrigin.Vedal: [
        NeuroActionCategory.Question,
        NeuroActionCategory.Answer,
        NeuroActionCategory.PogStuff, 
        NeuroActionCategory.AboutHerself, 
        NeuroActionCategory.InterestingStuff, 
        NeuroActionCategory.CorpaMoment, 
    ],
    NeuroActionOrigin.Donation: [
        NeuroActionCategory.None, 
    ],
    NeuroActionOrigin.Bomb: [
        NeuroActionCategory.None, 
    ],
}

var _current_fixation_category: NeuroActionCategory
@export var fixation_weight_growth: float = 0.2


func reset():
    filter_power = 0.0
    schizo_power = 0.0
    sleepy_power = 0.0
    justice_factor = 0.0
    emotional_state = 0.0

    karaoke_active = false
    sleep_active = false
    donowall_active = false
    timeout_block_active = false

    _action_count = 0
    _has_vedal_appeared = false

    prev_action_was_bomb = false
    prev_action_had_cookie = false

    latest_bomb_defused_successfully = false

    reset_fixation()


func _ready():
    randomize()
    reset()


func _update_fixation() -> void:
    category_weights[_current_fixation_category] += fixation_weight_growth


func reset_fixation() -> void:
    for category in category_weights.keys():
        category_weights[category] = 1
    _current_fixation_category = category_weights.keys().pick_random()


func plan_random_action() -> NeuroPlannedAction:
    var origin = WeightedRandom.pick_random(origin_weights)
    
    var category: NeuroActionCategory
    if origin == NeuroActionOrigin.Vedal and not _has_vedal_appeared:
        category = NeuroActionCategory.HiChat
        _has_vedal_appeared = true
    else:
        var categories := {}
        for cat in _categories_by_origin[origin]:
            categories[cat] = category_weights[cat] if cat in category_weights else 1

        category = WeightedRandom.pick_random(categories)

    var action = NeuroLogic.NeuroPlannedAction.new()
    action.origin = origin
    action.category = category
    return action


func is_sleeping() -> bool:
    return sleep_active


func _do_natural_growth() -> void:
    update_filter_power(randf_range(filter_growth_per_action / 2, filter_growth_per_action * 2))
    update_schizo_power(randf_range(schizo_growth_per_action / 2, schizo_growth_per_action * 2))
    if _action_count % sleepy_growth_interval == 0:
         update_sleepy_power(sleepy_growth)
    
    justice_factor = sin(_action_count * justice_factor_variance_frequency * TAU)

    if abs(emotional_state) < emotional_state_random_area:
        emotional_state += randf_range(-1, 1) * emotional_state_random_amount
    else:
        emotional_state *= emotional_state_variance_multiplier
    emotional_state = clamp(emotional_state, -1, 1)


func update_filter_power(delta: float) -> void:
    filter_power += delta
    filter_power = clamp(filter_power, -1, 1)


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


func update_donowall_status(active: bool) -> void:
    donowall_active = active
    donowall_status_changed.emit(donowall_active)


func update_karaoke_status(active: bool) -> void:
    karaoke_active = active

    if karaoke_active:
        emotional_state = 0
    
    karaoke_status_changed.emit(karaoke_active)


func update_sleep_status(active: bool) -> void:
    sleep_active = active
    sleep_status_changed.emit(sleep_active)


func update_timeout_block_status(active: bool) -> void:
    timeout_block_active = active


func give_cookie() -> void:
    prev_action_had_cookie = true


func _make_final_action(planned_action: NeuroPlannedAction, intention: float):
    var final_action = NeuroFinalAction.new()
    final_action.category = planned_action.category
    final_action.origin = planned_action.origin
    final_action.intention = intention
    final_action.is_tutel_receiver = planned_action.origin == NeuroActionOrigin.Vedal
    return final_action


func generate_response(action: NeuroPlannedAction) -> NeuroFinalAction:
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

    latest_bomb_defused_successfully = prev_action_was_bomb and prev_action_had_cookie

    neuro_action_started.emit(chain.action)
    prev_action_had_cookie = false
    prev_action_was_bomb = chain.action.origin == NeuroActionOrigin.Bomb

    _action_count += 1
    _do_natural_growth()
    _update_fixation()

    return chain.action


func _handle_filter(chain: NeuroFinalActionChain) -> void:
    var random = randf()
    var filter_prob = max(0, filter_power)
    var no_filter_prob = max(0, -filter_power)

    if random < filter_prob:
        chain.action.action_oopsie = NeuroActionOopsie.Filtered
        chain.keep_going = false
    if random < no_filter_prob:
        chain.action.contains_bad_words = true


func _handle_schizo(chain: NeuroFinalActionChain) -> void:
    chain.action.schizo_factor = schizo_power


func _handle_sleepy(chain: NeuroFinalActionChain) -> void:
    if randf() < sleepy_power:
        sleep_active = true

    if sleep_active:
        chain.action.action_oopsie = NeuroActionOopsie.None
        chain.keep_going = false


func _handle_timeouts(chain: NeuroFinalActionChain) -> void:
    if randf() < justice_factor and not timeout_block_active:
        chain.action.neuro_timeouted_someone = true


func _handle_donowall(chain: NeuroFinalActionChain) -> void:
    if donowall_active:
        chain.action.action_oopsie = NeuroActionOopsie.Ignored
        chain.keep_going = false


func _handle_karaoke(chain: NeuroFinalActionChain) -> void:
    if karaoke_active:
        chain.keep_going = false
