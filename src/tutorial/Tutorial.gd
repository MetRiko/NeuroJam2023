extends Control


func _ready():
	visible = true
	Game.get_gameplay_logic().game_over_ram.connect(_on_game_over)
	Game.get_gameplay_logic().game_over_viewers.connect(_on_game_over)
	Game.do_start.connect(_on_start)
	
func _on_game_over():
	visible = true
	
func _on_start():
	visible = false
