extends Node2D
class_name NeuroAction

var action : NeuroLogic.NeuroPlannedAction

var _is_new := true
var to_be_destroyed := false


func _ready():
    print("New planned action: category %s, origin %s" % [NeuroLogic.NeuroActionCategory.keys()[action.category], NeuroLogic.NeuroActionOrigin.keys()[action.origin]])

    $Sprite2D.scale = Vector2.ZERO

    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.2)


func update_pos(pos: Vector2) -> void:
    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(self, "position", pos, (0.2 if not _is_new else 0.0))
    _is_new = false


func execute() -> void:
    print("Execute action: category %s, origin %s" % [NeuroLogic.NeuroActionCategory.keys()[action.category], NeuroLogic.NeuroActionOrigin.keys()[action.origin]])

    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_parallel(true)
    tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
    if not to_be_destroyed:
        tween.tween_property(self, "position", Vector2.ZERO, 0.2)
    await tween.finished
    queue_free() 
