extends Node2D


@export var button: RigidBody2D
@export var button_pressed_threshold: float

@export var button_spring_force: float

@export var cooldown_time: float
@onready var cooldown_timer: Timer = $CooldownTimer

@export var timeout_disable_time: float
@onready var timeout_disable_timer: Timer = $TimeoutDisableTimer

@onready var cooldown_progress_bar: TextureProgressBar = $CooldownProgressBar

@onready var _button_hit_audio: AudioStreamPlayer = $ButtonHitAudio
@onready var _cooldown_over_audio: AudioStreamPlayer = $CooldownOverAudio


var _prev_button_pressed: bool
var _on_cooldown := false


# Called when the node enters the scene tree for the first time.
func _ready():
    cooldown_timer.timeout.connect(func(): _cooldown_over_audio.play(); _on_cooldown = false)


func _process(delta):
    var button_pressed = button.position.x > button_pressed_threshold
    if button_pressed and not _prev_button_pressed:
        _on_button_pressed()
    _prev_button_pressed = button_pressed

    if _on_cooldown:
        cooldown_progress_bar.value = lerp(cooldown_progress_bar.min_value, cooldown_progress_bar.max_value, cooldown_timer.time_left / cooldown_time)
    else:
        cooldown_progress_bar.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    button.apply_central_force(Vector2.LEFT * button_spring_force * (-1 if _on_cooldown else 1))


func _on_button_pressed() -> void:
    if not _on_cooldown:
        print("Disable timeouts for %s secs" % timeout_disable_time)
        _on_cooldown = true

        cooldown_timer.start(cooldown_time)
        timeout_disable_timer.start(timeout_disable_time)
        _button_hit_audio.play()

        Game.get_neuro_logic().update_timeout_block_status(true)

        await timeout_disable_timer.timeout
        Game.get_neuro_logic().update_timeout_block_status(false)
        

