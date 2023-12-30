extends Node2D

@onready var _lever_handle: RigidBody2D = $Handle
@onready var _lever_ball: RigidBody2D = $Handle/Ball
@onready var _lever_joint: PinJoint2D = $PinJoint2D

@onready var _filter_lower_timer: Timer = $FilterLowerTimer

@export var lever_torque: float = -50

@export var filter_lower_amount: float = 0.05
@export var filter_lower_interval: float = 0.7

@export var trigger_angle: float = -18
@export var untrigger_angle: float = 18

@onready var filter_on_audio: AudioStreamPlayer = $FilterOnAudio
@onready var filter_off_audio: AudioStreamPlayer = $FilterOffAudio

var _status: bool = false
var _prev_status: bool = false

var state := 1


# Called when the node enters the scene tree for the first time.
func _ready():
    _filter_lower_timer.timeout.connect(lower_filter)
    _filter_lower_timer.start(filter_lower_interval)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    match state:
        0:
            if _lever_handle.rotation_degrees > trigger_angle:
                state = 1
                filter_on()
        1:
            if _lever_handle.rotation_degrees > untrigger_angle:
                state = 2
            elif _lever_handle.rotation_degrees < trigger_angle:
                state = 0
        2:
            if _lever_handle.rotation_degrees < untrigger_angle:
                state = 1
                filter_off()


func filter_on():
    print("Filter on")
    filter_off_audio.stop()
    filter_on_audio.play()


func filter_off():
    print("Filter off")
    filter_on_audio.stop()
    filter_off_audio.play()


func lower_filter():
    if state == 1:
        print("Lower filter by %s" % filter_lower_amount)
        Game.get_neuro_logic().update_filter_power(-filter_lower_amount)


func _physics_process(delta):
    _lever_handle.apply_torque_impulse(lever_torque)
