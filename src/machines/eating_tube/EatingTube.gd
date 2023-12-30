extends Node2D

@onready var eat_trigger_area: Area2D = $EatTrigger

@export var schizo_lower_amount: float

@onready var _tube_enter_audio: AudioStreamPlayer = $TubeEnterAudio
@onready var _eat_cookie_audio: AudioStreamPlayer = $EatCookieAudio
@onready var _eat_schizo_pill_audio: AudioStreamPlayer = $EatSchizoPillAudio

@onready var _audio_delay_timer: Timer = $AudioDelay


# Called when the node enters the scene tree for the first time.
func _ready():
    eat_trigger_area.body_entered.connect(_on_eat)


func _on_eat(body):
    if body is SchizoPill:
        eat_schizo_pill()
        body.queue_free()
    elif body is Cookie:
        eat_cookie()
        body.queue_free()


func eat_schizo_pill():
    print("Lower schizo by %s" % schizo_lower_amount)
    Game.get_neuro_logic().update_schizo_power(-schizo_lower_amount)

    _tube_enter_audio.play()
    _audio_delay_timer.start()
    await _audio_delay_timer.timeout
    _eat_schizo_pill_audio.play()


func eat_cookie():
    print("Set cookie flag")
    Game.get_neuro_logic().give_cookie()

    _tube_enter_audio.play()
    _audio_delay_timer.start()
    await _audio_delay_timer.timeout
    _eat_cookie_audio.play()
