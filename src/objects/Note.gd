extends Node2D
class_name Note

signal destroy

@onready var area: Area2D = $Area2D

func _ready():
    area.body_entered.connect(_on_body_entered)

    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    tween.tween_property($Sprite2D, "scale", Vector2.ONE * 0.2, 0.2)


func _on_body_entered(body):
    if body is Player:
        destroy.emit()
        var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
        tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.2)
        tween.tween_callback(queue_free)
