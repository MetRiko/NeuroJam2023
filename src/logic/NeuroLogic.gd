extends Node
class_name NeuroLogic


enum NeuroResponseType { SPEAK, SLEEPY, IGNORE }


class NeuroResponse:
	var type: NeuroResponseType
	var content: String

	func _init(type: NeuroResponseType = NeuroResponseType.SPEAK, content: String = ""):
		self.type = type
		self.content = content


class WeightedNeuroResponse:
	var response: NeuroResponse
	var weight: int

	func _init(response: NeuroResponse, weight: int):
		self.response = response
		self.weight = weight


@export var filter_power := 0.5					# Relative to the probability of a response getting filtered (and of bad messages being let through) - 0.5: sweet spot
@export var schizo_power := 0					# Probability of Neuro going wild with her response
@export var sleepy_power := 0					# Probability of Neuro going Bedge instead of responding to an action
@export var donowall_power := 0					# Probability of Neuro ignoring an action
@export var clap_command_anger := 0				# Probability of Neuro responding to an action with being angry at the 'clap' command
@export var emotional_state := 0.5				# Neuro's emotional state: 0 - extremely hateful, 0.5 - neutral, 1 - extremely lovely
@export var memory_solidification_power := 0	# Probability of Neuro repeating one single thing in her responses
@export var thanking_power := 0					# Probability of Neuro choosing to thank for a sub/bits/dono instead of handling a chat action

var _response_file_path = "res://src/neuro_responses/responses.json"
var _responses

const LOW_FILTER_POWER_RESPONSES = "low_filter_power"
const HIGH_FILTER_POWER_RESPONSES = "high_filter_power"
const HIGH_SCHIZO_POWER_RESPONSES = "high_schizo_power"
const CLAP_COMMAND_ANGRY_RESPONSES = "clap_command_angry"
const HATEFUL_RESPONSES = "hateful"
const LOVELY_RESPONSES = "lovely"
const SOLIDIFIED_MEMORY_RESPONSES = "solidified_memory"
const SUB_THANK_RESPONSES = "sub_thank"
const BITS_THANK_RESPONSES = "bits_thank"
const DONO_THANK_RESPONSES = "dono_thank"
const NORMAL_RESPONSES = "normal"


func _get_speak_responses(type: String) -> Array:
	return _responses["responses"][type].map(func(response): return NeuroResponse.new(NeuroResponseType.SPEAK, response))


func _make_weighted_responses(responses: Array, weight: int) -> Array:
	return responses.map(func(response): return WeightedNeuroResponse.new(response, weight))


func _add_responses(response_pool: Array, responses: Array, weight: int) -> void:
	response_pool.append_array(_make_weighted_responses(responses, clamp(weight, 1, 1000000)))


func generate_response(action_type: NeuroAction.Type) -> NeuroResponse:
	var response_pool: Array = []

	_handle_filter(response_pool)
	_handle_schizo(response_pool)
	_handle_sleepy(response_pool)
	_handle_donowall(response_pool)
	_handle_clap_command_anger(response_pool)
	_handle_emotional_state(response_pool)
	_handle_memory_solidification(response_pool)
	_handle_thanks(response_pool)

	_add_responses(response_pool, _get_speak_responses(NORMAL_RESPONSES), 1)

	print(response_pool)

	return _pick_random_response(response_pool)


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


func _handle_filter(response_pool: Array) -> void:
	var random = randf()
	var filter_prob = max(0, (filter_power - 0.5) * 2)
	var no_filter_prob = max(0, (0.5 - filter_power) * 2)

	if random < filter_prob:
		_add_responses(response_pool, _get_speak_responses(HIGH_FILTER_POWER_RESPONSES), clamp(pow(filter_prob * 10, 2), 1, 100))
	if random < no_filter_prob:
		_add_responses(response_pool, _get_speak_responses(LOW_FILTER_POWER_RESPONSES), clamp(pow(no_filter_prob * 10, 2), 1, 100))


func _handle_schizo(response_pool: Array) -> void:
	var random = randf()
	if random < schizo_power:
		_add_responses(response_pool, _get_speak_responses(HIGH_SCHIZO_POWER_RESPONSES), clamp(pow(random * 10, 2), 1, 100))


func _handle_sleepy(response_pool: Array) -> void:
	var random = randf()
	if random < sleepy_power:
		_add_responses(response_pool, [NeuroResponse.new(NeuroResponseType.SLEEPY)], int(random * 200))


func _handle_donowall(response_pool: Array) -> void:
	var random = randf()
	if random < donowall_power:
		_add_responses(response_pool, [NeuroResponse.new(NeuroResponseType.IGNORE)], int(random * 200))


func _handle_clap_command_anger(response_pool: Array) -> void:
	var random = randf()
	if random < clap_command_anger:
		_add_responses(response_pool, _get_speak_responses(CLAP_COMMAND_ANGRY_RESPONSES), clamp(pow(random * 10, 2), 1, 100))


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
	if random < memory_solidification_power:
		_add_responses(response_pool, _get_speak_responses(SOLIDIFIED_MEMORY_RESPONSES), clamp(pow(random * 10, 2), 1, 100))


func _handle_thanks(response_pool: Array) -> void:
	var random = randf()
	if random < thanking_power:
		response_pool = _make_weighted_responses(_get_speak_responses(SUB_THANK_RESPONSES), 1000)
		_add_responses(response_pool, _get_speak_responses(BITS_THANK_RESPONSES), 1000)
		_add_responses(response_pool, _get_speak_responses(DONO_THANK_RESPONSES), 1000)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	if FileAccess.file_exists(_response_file_path):
		var file = FileAccess.open(_response_file_path, FileAccess.READ)
		_responses = JSON.parse_string(file.get_as_text())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
