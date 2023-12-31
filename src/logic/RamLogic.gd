extends Node
class_name RamLogic


@export var _current_ram := 0.0

var current_ram:
    get:
        return _current_ram
    set(value):
        _current_ram = value
        ram_changed.emit(_current_ram)
    
@export var max_ram := 100.0

var _prev_ram: float

var _logic_active := false

signal ram_changed(new_ram: float)
signal ram_maxed_out


# Called when the node enters the scene tree for the first time.
func _ready():
    Game.do_pause.connect(_on_pause)
    Game.do_reset.connect(_on_reset)
    Game.do_start.connect(_on_start)
    
    _on_reset()


func _on_pause():
    _logic_active = false
    
    
func _on_reset():
    current_ram = 0.0


func _on_start():
    _logic_active = true


func add_ram(delta: float) -> void:
    current_ram += delta
    current_ram = clamp(current_ram, 0.0, max_ram)
    if current_ram == max_ram and _prev_ram != max_ram:
        ram_maxed_out.emit()
    _prev_ram = current_ram
