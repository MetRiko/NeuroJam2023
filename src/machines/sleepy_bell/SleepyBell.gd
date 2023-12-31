extends BaseMachine


@export var bell: Grabbable
@export var ding_threshold: float

@export var sleepy_lower_amount: float

var _prev_bell_angular_velocity: float

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var ram_cost: float = 0.05


func _ready():
    Game.do_pause.connect(deactivate_machine)
    Game.do_start.connect(activate_machine)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var bell_angular_velocity = bell.angular_velocity * delta
    var vel_delta = bell_angular_velocity - _prev_bell_angular_velocity

    if abs(vel_delta) > ding_threshold:
        ding()
    
    _prev_bell_angular_velocity = bell_angular_velocity


func ding():
    if machine_active:
        print("Lower sleepy power by %s" % sleepy_lower_amount)
        Game.get_neuro_logic().update_sleepy_power(-sleepy_lower_amount)
        Game.get_neuro_logic().update_sleep_status(false)
        Game.get_ram_logic().add_ram(ram_cost)

    audio_stream_player.play()
