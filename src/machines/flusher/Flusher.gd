extends Node2D

@export var donowall_time: float


@onready var _handle: FlusherHandle = $Handle
@onready var _donowall_timer: Timer = $DonowallTimer
@onready var _flush_audio: AudioStreamPlayer = $FlushAudio

@export var core_machine: CoreMachine


# Called when the node enters the scene tree for the first time.
func _ready():
    _handle.flush.connect(_on_flush)


func _on_flush():
    if not Game.get_neuro_logic().donowall_active:
        print("Reset speedup, donowall on for %s secs" % donowall_time)
        Game.get_neuro_logic().update_donowall_status(true)
        core_machine.reset_intervals()
        _flush_audio.play()

        _donowall_timer.start(donowall_time)
        await _donowall_timer.timeout
        
        Game.get_neuro_logic().update_donowall_status(false)
