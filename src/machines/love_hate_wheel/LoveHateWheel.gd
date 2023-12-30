extends Node2D


@export var love_status_texture: Texture2D
@export var hate_status_texture: Texture2D
@export var status_sprite: Sprite2D

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


# Called when the node enters the scene tree for the first time.
func _ready():
    _love_audio.volume_db = -80
    _hate_audio.volume_db = -80

    _love_audio.play()
    _hate_audio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    _wheel_speed = wheel.angular_velocity
    var brightness = clamp(abs(_wheel_speed / wheel_speed_for_max_brightness), 0, 1)
    status_sprite.modulate = Color(brightness, brightness, brightness)

    if _wheel_speed < 0:
        status_sprite.texture = hate_status_texture
    else:
        status_sprite.texture = love_status_texture

    _rotation_counter += _wheel_speed * delta
    if _rotation_counter > TAU / adjustment_resolution:
        _rotation_counter = 0
        increase_love()
        _tick_audio.play()
    elif _rotation_counter < -TAU / adjustment_resolution:
        _rotation_counter = 0
        increase_hate()
        _tick_audio.play()
    
    _love_audio.volume_db = Conversions.power_to_db(max(0, brightness * sign(_wheel_speed) * pad_volume))
    _hate_audio.volume_db = Conversions.power_to_db(max(0, brightness * -sign(_wheel_speed) * pad_volume))


func increase_love():
    print("Increase emotional state by %s" % (adjustment_per_revolution / adjustment_resolution))
    Game.get_neuro_logic().update_emotional_state(adjustment_per_revolution / adjustment_resolution)


func increase_hate():
    print("Decrease emotional state by %s" % (-adjustment_per_revolution / adjustment_resolution))
    Game.get_neuro_logic().update_emotional_state(-adjustment_per_revolution / adjustment_resolution)
