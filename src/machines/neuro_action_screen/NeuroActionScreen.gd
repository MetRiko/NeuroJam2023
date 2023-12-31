extends Control

@onready var label : Label = $LabelPivot/Label
@onready var label_pivot : Control = $LabelPivot

var karaoke_active := false
var latest_action : NeuroLogic.NeuroFinalAction = null

func _ready():
	randomize()
	_set_screen_text("")
	var neuro_logic := Game.get_neuro_logic()
	neuro_logic.neuro_action_started.connect(_on_neuro_action_started)
	neuro_logic.karaoke_status_changed.connect(_on_karaoke_status_changed)

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
				NeuroLogic.NeuroActionCategory.Question: _set_screen_text("Neuro is asking question to chat...")
				NeuroLogic.NeuroActionCategory.Answer: _set_screen_text("Neuro is answering queston to chat... ")
				NeuroLogic.NeuroActionCategory.PogStuff: _set_screen_text("Neuro is talking to chat...")
				NeuroLogic.NeuroActionCategory.AboutHerself: _set_screen_text("Neuro is talking to chat...")
				NeuroLogic.NeuroActionCategory.InterestingStuff: _set_screen_text("Neuro is talking to chat...")
				NeuroLogic.NeuroActionCategory.CorpaMoment: _set_screen_text("Neuro is talking to chat...")

		NeuroLogic.NeuroActionOrigin.Vedal:
			match neuro_action.category:
				NeuroLogic.NeuroActionCategory.HiChat: _set_screen_text("Neuro is saying \"Hi\" to Vedal!")
				NeuroLogic.NeuroActionCategory.Question: _set_screen_text("Neuro is asking question to Vedal...")
				NeuroLogic.NeuroActionCategory.Answer: _set_screen_text("Neuro is answering queston from Vedal... ")
				NeuroLogic.NeuroActionCategory.PogStuff: _set_screen_text("Neuro is talking to Vedal... ")
				NeuroLogic.NeuroActionCategory.AboutHerself: _set_screen_text("Neuro is talking to Vedal... ")
				NeuroLogic.NeuroActionCategory.InterestingStuff: _set_screen_text("Neuro is talking to Vedal... ")
				NeuroLogic.NeuroActionCategory.CorpaMoment: _set_screen_text("Neuro is talking to Vedal... ")

		NeuroLogic.NeuroActionOrigin.Donation:
			match randi_range(0, 3):
				0:	_set_screen_text("Neuro is thanking for sub...")
				1:	_set_screen_text("Neuro is thanking for gifted subs...")
				2:	_set_screen_text("Neuro is thanking for follow...")
				3:	_set_screen_text("Neuro is thanking for bits...")
