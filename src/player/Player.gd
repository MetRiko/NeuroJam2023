extends RigidBody2D
class_name Player


@export var max_speed: float
@export var max_distance_to_accel: float
@export var speed_easing: float = 0.3

@export var rotation_amount: float
@export var rotation_easing: float = 0.3

@onready var _sprite = $Sprite2D
@onready var _interaction_joint = $InteractionJoint2D
@onready var _interaction_area = $InteractionArea2D


var _interactables: Array[Interactable] = []
var _nearest_interactable: Interactable

var thing_to_grab: Grabbable = null

@export var kp: float
@export var ki: float
@export var kd: float
var _error_prior: Vector2
var _integral_prior: Vector2


func _ready():
	_interaction_area.body_entered.connect(_on_enter_body)
	_interaction_area.body_exited.connect(_on_exit_body)


func _on_enter_body(body) -> void:
	if body is Interactable:
		_interactables.append(body)
		_nearest_interactable = find_nearest_interactable()


func _on_exit_body(body) -> void:
	if body is Interactable:
		_interactables.erase(body)
		body.stop_interacting()
		_nearest_interactable = find_nearest_interactable()


func find_nearest_interactable() -> Interactable:
	if len(_interactables) == 0:
		return null

	var nearest_interactable = _interactables[0]
	for interactable in _interactables:
		if (position - interactable.position).length_squared() < (position - nearest_interactable.position).length_squared():
			nearest_interactable = interactable

	return nearest_interactable


func connect_joint(body: Grabbable) -> void:
	if body.reset_position_on_grab:
		body.set_new_position(_interaction_joint.global_position)
	thing_to_grab = body


func disconnect_joint() -> void:
	_interaction_joint.node_b = ""


func _physics_process(delta):
	var error := get_global_mouse_position() - position
	var integral: Vector2 = _integral_prior + error * delta
	var derivative: Vector2 = (error - _error_prior) / delta
	var output = kp * error + ki * integral + kd * derivative 

	apply_central_force(output)

	_error_prior = error
	_integral_prior = integral

	_sprite.rotation_degrees = ease(abs(linear_velocity.x / max_speed), rotation_easing) * rotation_amount * sign(linear_velocity.x)

	if thing_to_grab != null:
		_interaction_joint.node_b = thing_to_grab.get_path()
		thing_to_grab = null

	if Input.is_action_just_pressed("Interact") and len(_interactables) > 0:		
		print(_nearest_interactable)

		_nearest_interactable.start_interacting()
		if _nearest_interactable is Grabbable:
			connect_joint(_nearest_interactable)
	elif Input.is_action_just_released("Interact"):
		if _nearest_interactable != null:
			_nearest_interactable.stop_interacting()
		disconnect_joint()
