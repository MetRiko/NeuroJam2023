extends Control

@onready var label : Label = $Label

func _ready():
	randomize()
	_set_screen_text("")
	var neuro_logic := Game.get_neuro_logic()
	neuro_logic.neuro_action_started.connect(_on_neuro_action_started)
	#neuro_logic.neuro_karaoke_state_changed.connect(_on_neuro_action_started)

func _set_screen_text(text : String) -> void:
	label.text = text

func _on_neuro_action_started(neuro_action : NeuroLogic.NeuroFinalAction) -> void:
	match neuro_action.category:
		NeuroLogic.NeuroActionCategory.HiChat:
			_set_screen_text("Neuro is saying \"Hi\"!")
		NeuroLogic.NeuroActionCategory.Joke:
			_set_screen_text("Neuro is telling a joke...")
		NeuroLogic.NeuroActionCategory.Story:
			_set_screen_text("Neuro is telling a story...")
		NeuroLogic.NeuroActionCategory.Question:
			_set_screen_text("Neuro is asking question...")
		NeuroLogic.NeuroActionCategory.Answer:
			_set_screen_text("Neuro is answering queston... ")
		# NeuroLogic.NeuroActionCategory.PogStuff:
		# NeuroLogic.NeuroActionCategory.AboutHerself:
		# NeuroLogic.NeuroActionCategory.InterestingStuff:
		# NeuroLogic.NeuroActionCategory.CorpaMoment:
		_:
			match neuro_action.origin:
				NeuroLogic.NeuroActionOrigin.Neuro:
					_set_screen_text("Neuro is talking...")
				NeuroLogic.NeuroActionOrigin.Chat:
					_set_screen_text("Neuro is talking to chat...")
				NeuroLogic.NeuroActionOrigin.Vedal:
					_set_screen_text("Neuro is talking to Vedal...")
				NeuroLogic.NeuroActionOrigin.Donation:
					match randi_range(0, 3):
						0:	_set_screen_text("Neuro is thanking for sub...")
						1:	_set_screen_text("Neuro is thanking for gifted subs...")
						2:	_set_screen_text("Neuro is thanking for follow...")
						3:	_set_screen_text("Neuro is thanking for bits...")

