extends Control

@export var progress_bar: TextureProgressBar

var _target_val: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    Game.get_ram_logic().ram_changed.connect(update_progress_bar)
    Game.get_gameplay_logic().game_over_ram.connect(func(): _target_val = 1000)


func _process(delta):
    progress_bar.value = lerp(progress_bar.value, _target_val, 10 * delta)


func update_progress_bar(current_ram: float):
    _target_val = current_ram / Game.get_ram_logic().max_ram * progress_bar.max_value
