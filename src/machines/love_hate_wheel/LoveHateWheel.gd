extends BaseMachine


@export var love_status_texture: Texture2D
@export var hate_status_texture: Texture2D
@export var love_label: Label
@export var hate_label: Label

@export var adjustment_per_revolution: float
@export var adjustment_resolution: float = 16

@export var wheel: RigidBody2D

var _wheel_speed: float
@export var wheel_speed_for_max_brightness: float

@onready var _love_audio: AudioStreamPlayer = $LoveAudio
@onready var _hate_audio: AudioStreamPlayer = $HateAudio
@onready var _tick_audio: AudioStreamPlayer = $TickAudio

@export var pad_volume: float = 0.5

var _rotation_counter: float = 0

@export var ram_cost: float = 0.05


# Called when the node enters the scene tree for the first time.
func _ready():
    _love_audio.volume_db = -80
    _hate_audio.volume_db = -80

    _love_audio.play()
    _hate_audio.play()
    
    Game.do_pause.connect(_on_pause)
    Game.do_start.connect(activate_machine)


func _on_pause():
    deactivate_machine()
    _love_audio.volume_db = -80
    _hate_audio.volume_db = -80

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    _wheel_speed = wheel.angular_velocity
    var brightness = clamp(_wheel_speed / wheel_speed_for_max_brightness, -1, 1)
    
    var love_brightness = max(0, brightness)
    var hate_brightness = max(0, -brightness)
    love_label.modulate = Color(love_brightness, love_brightness, love_brightness, love_brightness)
    hate_label.modulate = Color(hate_brightness, hate_brightness, hate_brightness, hate_brightness)

    _rotation_counter += _wheel_speed * delta
    if _rotation_counter > TAU / adjustment_resolution:
        _rotation_counter = 0
        increase_love()
        _tick_audio.play()
    elif _rotation_counter < -TAU / adjustment_resolution:
        _rotation_counter = 0
        increase_hate()
        _tick_audio.play()
    
    if machine_active:
        _love_audio.volume_db = Conversions.power_to_db(max(0, love_brightness * pad_volume))
        _hate_audio.volume_db = Conversions.power_to_db(max(0, hate_brightness * pad_volume))


func increase_love():
    if machine_active:
        print("Increase emotional state by %s" % (adjustment_per_revolution / adjustment_resolution))
        Game.get_neuro_logic().update_emotional_state(adjustment_per_revolution / adjustment_resolution)
        Game.get_ram_logic().add_ram(ram_cost)


func increase_hate():
    if machine_active:
        print("Decrease emotional state by %s" % (-adjustment_per_revolution / adjustment_resolution))
        Game.get_neuro_logic().update_emotional_state(-adjustment_per_revolution / adjustment_resolution)
        Game.get_ram_logic().add_ram(ram_cost)
