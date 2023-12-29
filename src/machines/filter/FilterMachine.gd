extends Node2D

@onready var _lever_handle: RigidBody2D = $Handle
@onready var _lever_joint: PinJoint2D = $PinJoint2D

@onready var _filter_lower_timer: Timer = $FilterLowerTimer

@export var lever_torque: float = -50

@export var filter_lower_amount: float = 0.05
@export var filter_lower_interval: float = 0.7


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if _lever_handle.rotation_degrees > rad_to_deg(_lever_joint.angular_limit_upper) / 2 - 5:
        if _filter_lower_timer.time_left == 0:
            _filter_lower_timer.start(filter_lower_interval)
            await _filter_lower_timer.timeout
            lower_filter()


func lower_filter():
    print("Lower filter by %s" % filter_lower_amount)


func _physics_process(delta):
    _lever_handle.apply_torque_impulse(lever_torque)
    # TODO: Fix lever snapping to the other side
