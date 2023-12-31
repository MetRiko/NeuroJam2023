extends Control
class_name DarkOverlay

@export var starting_transparency: float
@export var initial_delay: float
@export var final_transparency: float

func _set_transparency(value: float, duration: float) -> void:
    var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color(1, 1, 1, value), duration)


# Called when the node enters the scene tree for the first time.
func _ready():
    modulate = Color(1, 1, 1, starting_transparency)
    await get_tree().create_timer(initial_delay).timeout
    _set_transparency(final_transparency, 2)
    _setup()

func _setup():
    pass
