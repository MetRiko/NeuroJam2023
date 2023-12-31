extends BaseMachine

@onready var eat_trigger_area: Area2D = $EatTrigger

@export var schizo_lower_amount: float

@onready var _tube_enter_audio: AudioStreamPlayer = $TubeEnterAudio
@onready var _eat_cookie_audio: AudioStreamPlayer = $EatCookieAudio
@onready var _eat_schizo_pill_audio: AudioStreamPlayer = $EatSchizoPillAudio

@onready var _audio_delay_timer: Timer = $AudioDelay

@export var cookie_ram_cost: float = 0.5
@export var schizo_pill_ram_cost: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
    eat_trigger_area.body_entered.connect(_on_eat)
    Game.do_pause.connect(deactivate_machine)
    Game.do_start.connect(activate_machine)


func _on_eat(body):
    if body is SchizoPill:
        eat_schizo_pill()
        body.queue_free()
    elif body is Cookie:
        eat_cookie()
        body.queue_free()


func eat_schizo_pill():
    _tube_enter_audio.play()
    
    if machine_active:
        print("Lower schizo by %s" % schizo_lower_amount)
        Game.get_neuro_logic().update_schizo_power(-schizo_lower_amount)
        Game.get_ram_logic().add_ram(schizo_pill_ram_cost)

        _audio_delay_timer.start()
        await _audio_delay_timer.timeout
        _eat_schizo_pill_audio.play()


func eat_cookie():
    _tube_enter_audio.play()
    
    if machine_active:
        print("Set cookie flag")
        Game.get_neuro_logic().give_cookie()
        Game.get_ram_logic().add_ram(cookie_ram_cost)

        _audio_delay_timer.start()
        await _audio_delay_timer.timeout
        _eat_cookie_audio.play()
