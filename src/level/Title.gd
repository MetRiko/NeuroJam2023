extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
    Game.do_start.connect(_disappear)
    Game.get_gameplay_logic().game_over_ram.connect(_appear)
    Game.get_gameplay_logic().game_over_viewers.connect(_appear)
    
    _appear()


func _disappear():
    var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
    tween.tween_property(self, "scale", Vector2(0.5, 0.5), 1.5)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.2)
    

func _appear():
    var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
    tween.tween_property(self, "scale", Vector2(1, 1), 1)
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
