extends RigidBody2D


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


func _ready():
	_interaction_area.body_entered.connect(_on_enter_body)
	_interaction_area.body_exited.connect(_on_exit_body)


func _on_enter_body(body: RigidBody2D) -> void:
	if body is Interactable:
		_interactables.append(body)
		_nearest_interactable = find_nearest_interactable()


func _on_exit_body(body: RigidBody2D) -> void:
	if body is Interactable:
		_interactables.erase(body)
		_nearest_interactable =  find_nearest_interactable()


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
	var pos_delta := get_global_mouse_position() - position
	var direction := pos_delta.normalized()
	var speed = ease(clamp(pos_delta.length() / max_distance_to_accel, 0, 1), speed_easing) * max_speed

	if pos_delta.length_squared() < 1:
		speed = Vector2.ZERO

	linear_velocity = direction * speed
	_sprite.rotation_degrees = ease(abs(linear_velocity.x / max_speed), rotation_easing) * rotation_amount * sign(linear_velocity.x)

	# _process_collisions()


	if thing_to_grab != null:
		_interaction_joint.node_b = thing_to_grab.get_path()
		thing_to_grab = null

	if Input.is_action_just_pressed("Interact") and len(_interactables) > 0:		
		print(_nearest_interactable)

		if _nearest_interactable is Grabbable:
			connect_joint(_nearest_interactable)
	elif Input.is_action_just_released("Interact"):
		disconnect_joint()


# func _process_collisions():
# 	for i in get_slide_collision_count():
# 		var collision := get_slide_collision(i)
# 		var body = collision.get_collider() as RigidBody2D
# 		if body == null:
# 			continue

# 		var point = collision.get_position() - body.global_position
# 		var force = 5000
# 		body.apply_impulse(-collision.get_normal() * force, point)
