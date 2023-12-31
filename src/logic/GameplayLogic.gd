extends Node
class_name GameplayLogic


signal game_over_viewers
signal game_over_ram


@onready var game_start_audio : AudioStreamPlayer = $GameStartAudio
@onready var game_end_audio : AudioStreamPlayer = $GameEndAudio


func _ready():
    Game.get_ram_logic().ram_maxed_out.connect(stop_game_ram)
    Game.get_viewership_logic().viewership_changed.connect(on_viewership_changed)

    Game.reset()

    await get_tree().process_frame
    Game.prepare()


func start():
    print("=== START GAME ===")
    Game.reset()
    Game.start()
    game_start_audio.play()


func stop_game_ram():
    print("=== GAME OVER - OUT OF RAM ===")
    Game.pause()
    game_over_ram.emit()
    game_end_audio.play()

    await get_tree().create_timer(7.0).timeout
    Game.reset()
    Game.prepare()


func on_viewership_changed(viewership: int):
    if viewership <= 0:
        stop_game_viewers()


func stop_game_viewers():
    print("=== GAME OVER - NO VIEWERS ===")
    Game.pause()
    game_over_viewers.emit()
    game_end_audio.play()

    await get_tree().create_timer(7.0).timeout
    Game.reset()
    Game.prepare()


