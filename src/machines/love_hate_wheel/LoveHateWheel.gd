extends Node2D


@export var love_status_texture: Texture2D
@export var hate_status_texture: Texture2D
@export var status_sprite: Sprite2D

@export var adjustment_per_revolution: float
@export var adjustment_resolution: float = 16

@export var wheel: RigidBody2D

var _wheel_speed: float
@export var wheel_speed_for_max_brightness: float

var _rotation_counter: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


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
    elif _rotation_counter < -TAU / adjustment_resolution:
        _rotation_counter = 0
        increase_hate()


func increase_love():
    print("Increase emotional state by %s" % (adjustment_per_revolution / adjustment_resolution))
    Game.get_neuro_logic().update_emotional_state(adjustment_per_revolution / adjustment_resolution)


func increase_hate():
    print("Decrease emotional state by %s" % (-adjustment_per_revolution / adjustment_resolution))
    Game.get_neuro_logic().update_emotional_state(-adjustment_per_revolution / adjustment_resolution)
