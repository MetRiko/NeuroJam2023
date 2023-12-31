extends RigidBody2D
class_name Player


@export var max_speed: float

@export var rotation_amount: float
@export var rotation_easing: float = 0.3

@onready var _sprite = $Sprite2D
@onready var _interaction_joint = $InteractionJoint2D
@onready var _interaction_area = $InteractionArea2D

@export var inbounds_area: Area2D

@onready var _move_audio: AudioStreamPlayer = $MoveAudio
@onready var _grab_audio: AudioStreamPlayer = $GrabAudio
@onready var _release_audio: AudioStreamPlayer = $ReleaseAudio


var _interactables: Array[Interactable] = []
var _nearest_interactable: Interactable

var thing_to_grab: Grabbable = null
var held_thing: Grabbable = null

@export var kp: float
@export var ki: float
@export var kd: float
var _error_prior: Vector2
var _integral_prior: Vector2

var _initial_pos: Vector2
var _reset_pos := false


func _ready():
    _interaction_area.body_entered.connect(_on_enter_body)
    _interaction_area.body_exited.connect(_on_exit_body)
    inbounds_area.body_exited.connect(_on_inbounds_area_exited)

    _initial_pos = position

    _move_audio.volume_db = -80
    _move_audio.play()


func _on_inbounds_area_exited(body) -> void:
    if body == self:
        _reset_pos = true


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
    _grab_audio.play()
    if body.reset_position_on_grab:
        body.set_new_position(_interaction_joint.global_position)
    thing_to_grab = body


func disconnect_joint() -> void:
    if held_thing != null:
        _release_audio.play()
    _interaction_joint.node_b = ""


func _process(delta):
    var vel_magnitude = linear_velocity.length()
    var hum_volume = clamp(vel_magnitude / max_speed, 0, 0.3)
    _move_audio.volume_db = Conversions.power_to_db(hum_volume)


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
        held_thing = thing_to_grab
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
        held_thing = null
            

func _integrate_forces(state):
    if _reset_pos:
        state.transform = Transform2D(0.0, _initial_pos)
    _reset_pos = false        
    
