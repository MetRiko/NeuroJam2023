extends CharacterBody2D


@export var max_speed: float
@export var max_distance_to_accel: float
@export var speed_easing: float = 0.3

@export var rotation_amount: float
@export var rotation_easing: float = 0.3

@onready var _sprite = $Sprite2D
@onready var _interaction_joint = $InteractionJoint2D
@onready var _interaction_area = $InteractionArea2D


var _interactables: Array[Grabbable] = []
var _nearest_interactable: Grabbable

var thing_to_grab: Grabbable = null


func _ready():
	_interaction_area.body_entered.connect(func(body): _interactables.append(body))
	_interaction_area.body_exited.connect(func(body): _interactables.erase(body))


func connect_joint(body: Grabbable) -> void:
	if body.reset_position_on_grab:
		body.set_new_position(_interaction_joint.global_position)
	thing_to_grab = body


func disconnect_joint() -> void:
	_interaction_joint.node_b = ""


func _physics_process(delta):
	var pos_delta := get_global_mouse_position() - position
	var direction := pos_delta.normalized()
	var speed = ease(clamp(pos_delta.length() / max_distance_to_accel, 0, 1), speed_easing) * max_speed

	if pos_delta.length_squared() < 1:
		speed = Vector2.ZERO

	velocity = direction * speed
	_sprite.rotation_degrees = ease(abs(velocity.x / max_speed), rotation_easing) * rotation_amount * sign(velocity.x)

	move_and_slide()

	if thing_to_grab != null:
		_interaction_joint.node_b = thing_to_grab.get_path()
		thing_to_grab = null

	if Input.is_action_just_pressed("Interact") and len(_interactables) > 0:
		var nearest_interactable = _interactables[0]
		for interactable in _interactables:
			if (position - interactable.position).length_squared() < (position - nearest_interactable.position).length_squared():
				nearest_interactable = interactable
		
		print(nearest_interactable)
		connect_joint(nearest_interactable)
	elif Input.is_action_just_released("Interact"):
		disconnect_joint()
