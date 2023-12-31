extends Node2D
class_name Note

signal collect
signal miss

@onready var area: Area2D = $Area2D
@onready var _timer: Timer = $Timer

@export var lifetime: float = 2

var _alive := true


func _ready():
    area.body_entered.connect(_on_body_entered)
    _timer.timeout.connect(timeout)
    _timer.start(lifetime)

    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.2)


func _on_body_entered(body):
    if body is Player and _alive:
        _alive = false
        collect.emit()
        disappear()


func timeout():
    miss.emit()
    disappear()


func disappear():
    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.2)
    await tween.finished
    queue_free()
