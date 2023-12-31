extends DarkOverlay


# Called when the node enters the scene tree for the first time.
func _setup():
    Game.do_start.connect(_on_start)
    Game.get_gameplay_logic().game_over_ram.connect(_on_game_over)
    Game.get_gameplay_logic().game_over_viewers.connect(_on_game_over)


func _on_start():
    _set_transparency(0, 0.7)


func _on_game_over():
    _set_transparency(final_transparency, 0.7)
