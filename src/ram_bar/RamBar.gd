extends Control

@export var progress_bar: TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
    Game.get_ram_logic().ram_changed.connect(update_progress_bar)


func update_progress_bar(current_ram: float):
    var val = current_ram / Game.get_ram_logic().max_ram * progress_bar.max_value
    progress_bar.value = val
