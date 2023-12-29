extends Node
class_name NeuroLogic


enum NeuroResponseType { SPEAK, SLEEPY, SINGING, TIMEOUT }


class NeuroResponse:
	var type: NeuroResponseType
	var content: String

	func _init(type: NeuroResponseType = NeuroResponseType.SPEAK, content: String = ""):
		self.type = type
		self.content = content

	func clone() -> NeuroResponse:
		return NeuroResponse.new(self.type, self.content)


class WeightedNeuroResponse:
	var response: NeuroResponse
	var weight: int

	func _init(response: NeuroResponse, weight: int):
		self.response = response
		self.weight = weight


@export var filter_power := 0.5					# Relative to the probability of a response getting filtered (and of bad messages being let through) - 0.5: sweet spot
@export var schizo_power := 0.0					# Probability of Neuro going wild with her response
@export var sleepy_power := 0.0					# Probability of Neuro going Bedge instead of responding to an action - do not click anything when sleepy, or else sleep increases
@export var justice_factor := 0.0				# Probability of Neuro responding to an action with timing a chatter out instead of normally - grows when there's a lot of clapping
@export var emotional_state := 0.5				# Neuro's emotional state: 0 - extremely hateful, 0.5 - neutral, 1 - extremely lovely
@export var memory_solidification_power := 0.0	# Probability of Neuro repeating one single thing in her responses

@export var timeout_threshold := 0.9			# When the justice factor is larger than this, every action will result in a timeout instead

@export var karaoke_active := false				# If active, all actions are ignored

var _response_file_path = "res://src/neuro_responses/responses.json"
var _responses

const LOW_FILTER_POWER_RESPONSES = "low_filter_power"
const HIGH_FILTER_POWER_RESPONSES = "high_filter_power"
const JUSTICE_FACTOR_ANGRY_RESPONSES = "justice_factor_angry"
const TIMEOUT_RESPONSES = "timeout"
const HATEFUL_RESPONSES = "hateful"
const LOVELY_RESPONSES = "lovely"
const SUB_THANK_RESPONSES = "sub_thank"
const BITS_THANK_RESPONSES = "bits_thank"
const DONO_THANK_RESPONSES = "dono_thank"
const NORMAL_RESPONSES = "normal"

var _last_response: NeuroResponse


func _get_speak_responses(type: String) -> Array:
	return _responses["responses"][type].map(func(response): return NeuroResponse.new(NeuroResponseType.SPEAK, response))


func _make_weighted_responses(responses: Array, weight: int) -> Array:
	return responses.map(func(response): return WeightedNeuroResponse.new(response, weight))


func _add_responses(response_pool: Array, responses: Array, weight: int) -> void:
	response_pool.append_array(_make_weighted_responses(responses, clamp(weight, 1, 1000000)))


func generate_response(action_type: NeuroAction.Type) -> NeuroResponse:
	var response_pool: Array = []

	var filtered := _handle_filter(response_pool)
	_handle_sleepy(response_pool)
	_handle_justice_factor_anger(response_pool)
	_handle_emotional_state(response_pool)

	var normal_response_type: String
	match action_type:
		NeuroAction.Type.SUB:
			normal_response_type = SUB_THANK_RESPONSES
		NeuroAction.Type.SUB_GIFT:
			normal_response_type = SUB_THANK_RESPONSES
		NeuroAction.Type.BITS:
			normal_response_type = BITS_THANK_RESPONSES
		NeuroAction.Type.DONATION:
			normal_response_type = DONO_THANK_RESPONSES
		_:
			normal_response_type = NORMAL_RESPONSES

	_add_responses(response_pool, _get_speak_responses(normal_response_type), 1)

	_handle_memory_solidification(response_pool)

	_handle_timeouts(response_pool)
	_handle_karaoke(response_pool)

	var response := _pick_random_response(response_pool)
	_last_response = response
	return _schizoify(response) if not filtered else response


func _pick_random_response(response_pool: Array) -> NeuroResponse:
	var sum_of_weights := 0
	for choice in response_pool:
		sum_of_weights += choice.weight
		
	if sum_of_weights == 0:
		return null

	var random := randi_range(0, sum_of_weights - 1)
	for choice in response_pool:
		if random < choice.weight:
			return choice.response
		random -= choice.weight
	
	return null


func _handle_filter(response_pool: Array) -> bool:
	var random = randf()
	var filter_prob = max(0, (filter_power - 0.5) * 2)
	var no_filter_prob = max(0, (0.5 - filter_power) * 2)

	if random < filter_prob:
		_add_responses(response_pool, _get_speak_responses(HIGH_FILTER_POWER_RESPONSES), clamp(pow(filter_prob, 2) * 1000, 1, 1000))
		return true
	if random < no_filter_prob:
		_add_responses(response_pool, _get_speak_responses(LOW_FILTER_POWER_RESPONSES), clamp(pow(no_filter_prob, 2) * 100, 1, 100))

	return false


func _schizoify(response: NeuroResponse) -> NeuroResponse:
	var random = randf()
	
	var new_response = response.clone()
	if new_response.type == NeuroResponseType.SPEAK and random < schizo_power:
		new_response.content += "@"

	return new_response


func _handle_sleepy(response_pool: Array) -> void:
	var random = randf()
	if random < sleepy_power:
		_add_responses(response_pool, [NeuroResponse.new(NeuroResponseType.SLEEPY)], int(random * 200))


func _handle_justice_factor_anger(response_pool: Array) -> void:
	var random = randf()
	if random < justice_factor:
		_add_responses(response_pool, _get_speak_responses(JUSTICE_FACTOR_ANGRY_RESPONSES), clamp(pow(random * 10, 2), 1, 100))


func _handle_emotional_state(response_pool: Array) -> void:
	var random = randf()
	var lovely_prob = max(0, (emotional_state - 0.5) * 2)
	var hateful_prob = max(0, (0.5 - emotional_state) * 2)

	if random < hateful_prob:
		_add_responses(response_pool, _get_speak_responses(HATEFUL_RESPONSES), clamp(pow(hateful_prob * 10, 2), 1, 100))
	if random < lovely_prob:
		_add_responses(response_pool, _get_speak_responses(LOVELY_RESPONSES), clamp(pow(lovely_prob * 10, 2), 1, 100))


func _handle_memory_solidification(response_pool: Array) -> void:
	var random = randf()
	if random < memory_solidification_power and _last_response != null:
		response_pool.clear()
		_add_responses(response_pool, [_last_response], clamp(pow(random * 10, 2), 1, 100))


func _handle_timeouts(response_pool: Array) -> void:
	if justice_factor >= timeout_threshold:
		response_pool.clear()
		response_pool.append_array(_make_weighted_responses([NeuroResponse.new(NeuroResponseType.TIMEOUT, "")], 100))


func _handle_karaoke(response_pool: Array) -> void:
	if karaoke_active:
		response_pool.clear()
		response_pool.append_array(_make_weighted_responses([NeuroResponse.new(NeuroResponseType.SINGING, "")], 100))


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	if FileAccess.file_exists(_response_file_path):
		var file = FileAccess.open(_response_file_path, FileAccess.READ)
		_responses = JSON.parse_string(file.get_as_text())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
