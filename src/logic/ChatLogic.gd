extends Node
class_name ChatLogic

signal chat_entry_added(entry : ChatEntryData)

class UserData:
	var color : Color = Color.CORNFLOWER_BLUE
	var username : String = "TestUser"
	var badge : Database.UserBadge = Database.UserBadge.None

class ContentDataBase:
	func get_text() -> String:
		return ""

class Emoji extends ContentDataBase:
	var emoji : Database.EmojiType = Database.EmojiType.None
	func get_text() -> String:
		return "[img=24]" + Database.emojis[emoji] + "[/img]" if emoji != Database.EmojiType.None else "[NONE_EMOJI]"

	func _init(emoji : Database.EmojiType):
		self.emoji = emoji
		
class Msg extends ContentDataBase:
	var text : String = ""
	func get_text() -> String:
		return text

	func _init(text : String):
		self.text = text
	
class ChatEntryData:
	var user_data : UserData
	var timeouted_user : String = ""
	var content : Array[ContentDataBase]
		
var chat_entries : Array[ChatEntryData] = []
var chat_cooldown_time := 0.0
var current_neuro_action : NeuroLogic.NeuroFinalAction = null
var previous_neuro_action : NeuroLogic.NeuroFinalAction = null
var bomb_hype := 0.0
var was_bomb_defused := false

var _logic_active := false

func get_chat_entries() -> Array[ChatEntryData]:
	return chat_entries 

func add_chat_entry(entry : ChatEntryData):
	chat_entries.push_back(entry)
	chat_entry_added.emit(entry)

func _ready():
	randomize()
	Game.get_neuro_logic().neuro_action_started.connect(_on_neuro_action_started)

	Game.do_start.connect(_on_start)
	Game.do_pause.connect(_on_pause)
	Game.do_reset.connect(_on_reset)

func _on_start():
	_logic_active = true

func _on_pause():
	_logic_active = false

func _on_reset():
	chat_entries.clear()
	chat_cooldown_time = 0.0
	current_neuro_action = null
	previous_neuro_action = null
	bomb_hype = 0.0
	was_bomb_defused = false
	chat_entry_added.emit(null)

var chance_to_react_to_previous_message := 0.0

func _on_neuro_action_started(neuro_action : NeuroLogic.NeuroFinalAction):
	previous_neuro_action = current_neuro_action

	if neuro_action != null and neuro_action.neuro_timeouted_someone:
		var username = "User_" + str(randi() % 100)
		var chat_entry := ChatLogic.ChatEntryData.new()
		chat_entry.timeouted_user = username
		add_chat_entry(chat_entry)

	if previous_neuro_action != null and previous_neuro_action.origin == NeuroLogic.NeuroActionOrigin.Bomb:
		var neuro_logic : NeuroLogic = Game.get_neuro_logic()
		bomb_hype = 1.0
		was_bomb_defused = neuro_logic.latest_bomb_defused_successfully

	current_neuro_action = neuro_action
	chance_to_react_to_previous_message = randf() * 0.3

func _process(delta):
	if _logic_active:
		chat_cooldown_time -= delta
		if chat_cooldown_time <= 0.0:
			chat_cooldown_time = randf_range(0.05, 0.3)
			_generate_matching_chat_entry()

func _queue_chat_response(response_category : ChatResponseCategory):
	if response_category == ChatResponseCategory.None:
		return

	var test_user := ChatLogic.UserData.new()
	test_user.badge = Database.UserBadge.Sub1
	test_user.username = "User_" + str(randi() % 100)
	test_user.color = Color.from_hsv(randf(), 0.7, 0.9)

	var chat_entry := ChatLogic.ChatEntryData.new()
	chat_entry.user_data = test_user
	var possible_answers : Array = Database.chat_answers[response_category]
	var arr : Array[ContentDataBase] = []
	arr.assign(possible_answers.pick_random())
	chat_entry.content = arr

	add_chat_entry(chat_entry)

enum ChatResponseCategory {
	None,	Karaoke, Bedge, Ignored, Filtered,
	Tutel, BadWords, Timeout, Schizo,
	Lovely_1, Lovely_2, Lovely_3, Evil_1, Evil_2, Evil_3,
	PogStuff, AboutHerself, InterestingStuff, Joke, Story, CorpaMoment, Question, Answer,
	HiChat, HiVedal,
	BombDefused, BombExploded, DefusingBomb
}

func _generate_matching_chat_entry():
	if bomb_hype > 0.0 and randf() < bomb_hype:
		bomb_hype -= randf_range(0.05, 0.1)
		var neuro_logic : NeuroLogic = Game.get_neuro_logic()
		if !neuro_logic.karaoke_active and !neuro_logic.sleep_active:
			var response_type := ChatResponseCategory.BombDefused if was_bomb_defused else ChatResponseCategory.BombExploded
			_queue_chat_response(response_type)
		return

	if randf() < chance_to_react_to_previous_message:
		chance_to_react_to_previous_message -= randf_range(0.05, 0.15)
		var response_category := _determine_chat_response_category(previous_neuro_action)
		_queue_chat_response(response_category)
	else:
		var response_category := _determine_chat_response_category(current_neuro_action)
		_queue_chat_response(response_category)

func _determine_chat_response_category(neuro_action : NeuroLogic.NeuroFinalAction) -> ChatResponseCategory:
	if neuro_action == null:
		return ChatResponseCategory.None

	var neuro_logic : NeuroLogic = Game.get_neuro_logic()
	if neuro_logic.karaoke_active:
		return ChatResponseCategory.Karaoke

	if neuro_logic.sleep_active:
		return ChatResponseCategory.Bedge

	match neuro_action.action_oopsie:
		NeuroLogic.NeuroActionOopsie.Ignored:
			return ChatResponseCategory.Ignored
		NeuroLogic.NeuroActionOopsie.Filtered:
			return ChatResponseCategory.Filtered

	# schizo_factor
	if randf() < neuro_logic.get_perceived_schizo_factor() * 1.5:
		return ChatResponseCategory.Schizo

	var post_additional_comment_instead := randf() < 0.2
	if post_additional_comment_instead:
		var comment_types := []
		if neuro_action.is_tutel_receiver:
			comment_types.append(1)
		if neuro_action.contains_bad_words:
			comment_types.append(2)
		if neuro_action.neuro_timeouted_someone:
			comment_types.append(3)

		if comment_types.size() > 0:
			match comment_types.pick_random():
				1:	return ChatResponseCategory.Tutel
				2:	return ChatResponseCategory.BadWords
				3:	return ChatResponseCategory.Timeout

	# pick reaction to intention
	var intention_factor := absf(neuro_action.intention)
	if randf() < intention_factor:
		var intetion_level := neuro_action.get_intention_level()
		match intetion_level:
			1: return ChatResponseCategory.Lovely_1
			2: return ChatResponseCategory.Lovely_2
			3: return ChatResponseCategory.Lovely_3
			-1: return ChatResponseCategory.Evil_1
			-2: return ChatResponseCategory.Evil_2
			-3: return ChatResponseCategory.Evil_3

	if neuro_action.origin == NeuroLogic.NeuroActionOrigin.Bomb:
		return ChatResponseCategory.DefusingBomb
				
	match neuro_action.category:
		NeuroLogic.NeuroActionCategory.PogStuff: return ChatResponseCategory.PogStuff
		NeuroLogic.NeuroActionCategory.AboutHerself: return ChatResponseCategory.AboutHerself
		NeuroLogic.NeuroActionCategory.InterestingStuff: return ChatResponseCategory.InterestingStuff
		NeuroLogic.NeuroActionCategory.Joke: return ChatResponseCategory.Joke
		NeuroLogic.NeuroActionCategory.Story: return ChatResponseCategory.Story
		NeuroLogic.NeuroActionCategory.CorpaMoment: return ChatResponseCategory.CorpaMoment
		NeuroLogic.NeuroActionCategory.Question: return ChatResponseCategory.Question
		NeuroLogic.NeuroActionCategory.Answer: return ChatResponseCategory.Answer
		NeuroLogic.NeuroActionCategory.HiChat:
			match neuro_action.origin:
				NeuroLogic.NeuroActionOrigin.Vedal: return ChatResponseCategory.HiVedal
				NeuroLogic.NeuroActionOrigin.Chat: return ChatResponseCategory.HiChat
	
	return ChatResponseCategory.None
