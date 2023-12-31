extends Control

@onready var label : Label = $LabelPivot/Label
@onready var label_pivot : Control = $LabelPivot
@onready var start_progress_bar : TextureProgressBar = $StartProgressBar
@onready var start_area: Area2D = $StartArea
@export var start_time: float = 2

@onready var sprite: Sprite2D = $Sprite2D

var start_progress: float = 0

var karaoke_active := false
var latest_action : NeuroLogic.NeuroFinalAction = null

var progress_bar_active := false
var player_inside := false

@onready var start_delay_timer: Timer = $StartDelayTimer

@onready var game_starting_audio : AudioStreamPlayer = $GameStartingAudio


func _ready():
    randomize()
    _set_screen_text("")
    var neuro_logic := Game.get_neuro_logic()
    neuro_logic.neuro_action_started.connect(_on_neuro_action_started)
    neuro_logic.karaoke_status_changed.connect(_on_karaoke_status_changed)
    Game.do_reset.connect(_on_do_reset)
    Game.do_prepare.connect(_on_prepare)

    start_area.body_entered.connect(_on_start_area_entered)
    start_area.body_exited.connect(_on_start_area_exited)

    Game.do_start.connect(_on_start)
    Game.get_gameplay_logic().game_over_ram.connect(_on_game_over_ram)
    Game.get_gameplay_logic().game_over_viewers.connect(_on_game_over_viewers)
    
    game_starting_audio.volume_db = -80
    game_starting_audio.play()
    sprite.frame = 0
    

func _on_start():
    sprite.frame = 1


func _on_game_over_ram() -> void:
    sprite.frame = 0
    _set_screen_text("Out of RAM!\nPeak viewers: %s\nTime survived: %s" % [int(Game.get_viewership_logic().peak_viewers / 10.0), StringUtils.timestamp(Game.get_viewership_logic().stream_time)])

func _on_game_over_viewers() -> void:
    sprite.frame = 0
    _set_screen_text("You lost all your viewers!\nPeak viewers: %s\nTime survived: %s" % [int(Game.get_viewership_logic().peak_viewers / 10.0), StringUtils.timestamp(Game.get_viewership_logic().stream_time)])

func _on_start_area_entered(body) -> void:
    if body is Player:
        player_inside = true

func _on_start_area_exited(body) -> void:
    if body is Player:
        player_inside = false

func _process(delta):
    if not progress_bar_active:
        game_starting_audio.volume_db = -80
    
    if progress_bar_active and start_delay_timer.time_left == 0:
        start_progress += delta / start_time * (1 if player_inside else -1)
        start_progress = clamp(start_progress, 0, 1)
        start_progress_bar.value = start_progress_bar.max_value * pow(start_progress, 3)

        game_starting_audio.pitch_scale = max(0.01, pow(start_progress, 3))
        game_starting_audio.volume_db = Conversions.power_to_db(start_progress) / 5

        if start_progress >= 1:
            Game.get_gameplay_logic().start()

func _on_do_reset() -> void:
    _set_screen_text("")
    
    if progress_bar_active:
        var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
        tween.tween_property(start_progress_bar, "modulate", Color(0, 0, 0, 0), 0.5)
    progress_bar_active = false

func _on_prepare() -> void:
    _set_screen_text("Hover here\nto start stream!\n ")
    progress_bar_active = true
    var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
    start_progress = 0
    tween.tween_property(start_progress_bar, "modulate", Color(1, 1, 1, 1), 0.5)     

func _on_karaoke_status_changed(karaoke_active : bool) -> void:
    _on_neuro_action_started(latest_action)

func _set_screen_text(text : String) -> void:
    if text == label.text:
        return

    label.text = text
    
    var tween := create_tween()
    label_pivot.scale = Vector2.ZERO
    tween.tween_property(label_pivot, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    tween.play()

func _on_neuro_action_started(neuro_action : NeuroLogic.NeuroFinalAction) -> void:
    latest_action = neuro_action
    var neuro_logic : NeuroLogic = Game.get_neuro_logic()
    if neuro_logic.karaoke_active:
        _set_screen_text("Neuro is singing!")
        return

    _set_screen_text("...")

    if neuro_action == null:
        return

    match neuro_action.origin:
        NeuroLogic.NeuroActionOrigin.Bomb:
            _set_screen_text("Neuro is trying to defuse a bomb...")

        NeuroLogic.NeuroActionOrigin.Neuro:
            match neuro_action.category:
                NeuroLogic.NeuroActionCategory.Joke: _set_screen_text("Neuro is telling a joke...")
                NeuroLogic.NeuroActionCategory.Story: _set_screen_text("Neuro is telling a story...")
                NeuroLogic.NeuroActionCategory.PogStuff: _set_screen_text("Neuro is talking...")
                NeuroLogic.NeuroActionCategory.AboutHerself: _set_screen_text("Neuro is talking...")
                NeuroLogic.NeuroActionCategory.InterestingStuff: _set_screen_text("Neuro is talking...")
                NeuroLogic.NeuroActionCategory.CorpaMoment: _set_screen_text("Neuro is talking...")
            
        NeuroLogic.NeuroActionOrigin.Chat:
            match neuro_action.category:
                NeuroLogic.NeuroActionCategory.HiChat: _set_screen_text("Neuro is saying \"Hi\" to chat!")
                NeuroLogic.NeuroActionCategory.Question: _set_screen_text("Neuro is asking chat a question...")
                NeuroLogic.NeuroActionCategory.Answer: _set_screen_text("Neuro is answering chat's question... ")
                NeuroLogic.NeuroActionCategory.PogStuff: _set_screen_text("Neuro is talking to chat...")
                NeuroLogic.NeuroActionCategory.AboutHerself: _set_screen_text("Neuro is talking to chat...")
                NeuroLogic.NeuroActionCategory.InterestingStuff: _set_screen_text("Neuro is talking to chat...")
                NeuroLogic.NeuroActionCategory.CorpaMoment: _set_screen_text("Neuro is talking to chat...")

        NeuroLogic.NeuroActionOrigin.Vedal:
            match neuro_action.category:
                NeuroLogic.NeuroActionCategory.HiChat: _set_screen_text("Neuro is saying \"Hi\" to Vedal!")
                NeuroLogic.NeuroActionCategory.Question: _set_screen_text("Neuro is asking Vedal a question...")
                NeuroLogic.NeuroActionCategory.Answer: _set_screen_text("Neuro is answering Vedal's question... ")
                NeuroLogic.NeuroActionCategory.PogStuff: _set_screen_text("Neuro is talking to Vedal... ")
                NeuroLogic.NeuroActionCategory.AboutHerself: _set_screen_text("Neuro is talking to Vedal... ")
                NeuroLogic.NeuroActionCategory.InterestingStuff: _set_screen_text("Neuro is talking to Vedal... ")
                NeuroLogic.NeuroActionCategory.CorpaMoment: _set_screen_text("Neuro is talking to Vedal... ")

        NeuroLogic.NeuroActionOrigin.Donation:
            match randi_range(0, 3):
                0:	_set_screen_text("Neuro is thanking for a sub...")
                1:	_set_screen_text("Neuro is thanking for gifted subs...")
                2:	_set_screen_text("Neuro is thanking for a follow...")
                3:	_set_screen_text("Neuro is thanking for bits...")
