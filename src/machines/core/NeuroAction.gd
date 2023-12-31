extends Node2D
class_name NeuroAction

var action : NeuroLogic.NeuroPlannedAction

var _is_new := true
var to_be_destroyed := false

func _update_icon():
    match action.origin:
        NeuroLogic.NeuroActionOrigin.Neuro: 
            $Sprite2D.frame = 0
        NeuroLogic.NeuroActionOrigin.Chat: 
            $Sprite2D.frame = 1
        NeuroLogic.NeuroActionOrigin.Vedal: 
            $Sprite2D.frame = 2
        NeuroLogic.NeuroActionOrigin.Donation: 
            $Sprite2D.frame = 3
        NeuroLogic.NeuroActionOrigin.Bomb: 
            $Sprite2D.frame = 4

func _ready():
    # print("New planned action: category %s, origin %s" % [NeuroLogic.NeuroActionCategory.keys()[action.category], NeuroLogic.NeuroActionOrigin.keys()[action.origin]])

    _update_icon()
    $Sprite2D.scale = Vector2.ZERO

    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    tween.tween_property($Sprite2D, "scale", Vector2.ONE * 1.4, 0.2)


func update_pos(pos: Vector2) -> void:
    var animation_speed := _get_animation_speed()
    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(self, "position", pos, (animation_speed if not _is_new else 0.0))
    _is_new = false

func _get_animation_speed() -> float:
    var core_machine := CoreMachine.get_machine()
    var base_execute_speed := core_machine.execute_action_interval
    var actual_execute_speed := core_machine._actual_execute_action_interval
    var animation_speed := actual_execute_speed / base_execute_speed
    animation_speed = max(0.02, animation_speed) * 0.45
    # animation_speed = 0.2 # original value
    return animation_speed

func execute() -> void:
    # print("Execute action: category %s, origin %s" % [NeuroLogic.NeuroActionCategory.keys()[action.category], NeuroLogic.NeuroActionOrigin.keys()[action.origin]])

    var animation_speed := _get_animation_speed()

    var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_parallel(true)
    tween.tween_property(self, "scale", Vector2.ZERO, animation_speed)
    if not to_be_destroyed:
        tween.tween_property(self, "position", Vector2.ZERO, animation_speed)
    await tween.finished
    queue_free() 
