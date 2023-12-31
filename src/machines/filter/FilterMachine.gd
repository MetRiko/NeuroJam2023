extends BaseMachine

@onready var _lever_handle: RigidBody2D = $Handle
@onready var _lever_ball: RigidBody2D = $Handle/Ball
@onready var _lever_joint: PinJoint2D = $PinJoint2D

@export var lever_torque: float = -50

@export var trigger_angle: float = -18
@export var untrigger_angle: float = 18

@onready var filter_on_audio: AudioStreamPlayer = $FilterOnAudio
@onready var filter_off_audio: AudioStreamPlayer = $FilterOffAudio

var state := 1
var _filter_active := false

@export var ram_cost_per_second = 0.2


func _ready():
    Game.do_pause.connect(_on_pause)
    Game.do_start.connect(_on_start)


func _on_pause():
    filter_off()
    deactivate_machine()
    _filter_active = false
    

func _on_start():
    filter_off()
    activate_machine()
    _filter_active = false


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
                filter_on()
            elif _lever_handle.rotation_degrees < trigger_angle:
                state = 0
                filter_off()
        2:
            if _lever_handle.rotation_degrees < untrigger_angle:
                state = 1
                filter_off()
    
    if _filter_active:
        Game.get_ram_logic().add_ram(ram_cost_per_second * delta)

func filter_on():
    if not _filter_active and machine_active:
        print("Filter on")
        filter_off_audio.stop()
        filter_on_audio.play()
        _filter_active = true
        Game.get_neuro_logic().update_filter_fast_mode(true)


func filter_off():
    if _filter_active and machine_active:
        print("Filter off")
        filter_on_audio.stop()
        filter_off_audio.play()
        _filter_active = false
        Game.get_neuro_logic().update_filter_fast_mode(false)


func _physics_process(delta):
    _lever_handle.apply_torque_impulse(lever_torque)
