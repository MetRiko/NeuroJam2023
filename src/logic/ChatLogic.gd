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
	var content : Array[ContentDataBase]
		
var chat_entries : Array[ChatEntryData] = []
var chat_cooldown_time := 0.0
var current_neuro_action : NeuroLogic.NeuroFinalAction = null
var previous_neuro_action : NeuroLogic.NeuroFinalAction = null

func get_chat_entries() -> Array[ChatEntryData]:
	return chat_entries 

func add_chat_entry(entry : ChatEntryData):
	chat_entries.push_back(entry)
	chat_entry_added.emit(entry)

func _ready():
	randomize()
	Game.get_neuro_logic().neuro_action_started.connect(_on_neuro_action_started)

var chance_to_react_to_previous_message := 0.0

func _on_neuro_action_started(neuro_action : NeuroLogic.NeuroFinalAction):
	previous_neuro_action = current_neuro_action
	current_neuro_action = neuro_action
	chance_to_react_to_previous_message = randf() * 0.5

func _process(delta):
	chat_cooldown_time -= delta
	if chat_cooldown_time <= 0.0:
		chat_cooldown_time = randf_range(0.02, 0.3)
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
	PogStuff, AboutHerself, InterestingStuff, Joke, Story, CorpaMoment, Question, Answer, HiChat
}

func _generate_matching_chat_entry():
	if randf() < chance_to_react_to_previous_message:
		chance_to_react_to_previous_message -= randf() * 0.15
		chance_to_react_to_previous_message = max(chance_to_react_to_previous_message, 0.0)
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

	match neuro_action.action_oopsie:
		NeuroLogic.NeuroActionOopsie.Slept:
			return ChatResponseCategory.Bedge
		NeuroLogic.NeuroActionOopsie.Ignored:
			return ChatResponseCategory.Ignored
		NeuroLogic.NeuroActionOopsie.Filtered:
			return ChatResponseCategory.Filtered

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

	# schizo_factor
	if randf() < neuro_action.schizo_factor:
		return ChatResponseCategory.Schizo

	# pick reaction to intention
	var intention_factor := absf(neuro_action.intention)
	if randf() < intention_factor:
		var intention_chance := randf() * intention_factor
		var is_lovely := neuro_action.intention > 0
		if intention_chance >= 0.7: # lvl 3
			return ChatResponseCategory.Lovely_3 if is_lovely else ChatResponseCategory.Evil_3
		elif intention_chance >= 0.4: # lvl 2
			return ChatResponseCategory.Lovely_2 if is_lovely else ChatResponseCategory.Evil_2
		elif intention_chance >= 0.15: # lvl 1
			return ChatResponseCategory.Lovely_1 if is_lovely else ChatResponseCategory.Evil_1

	match neuro_action.category:
		NeuroLogic.NeuroActionCategory.PogStuff: return ChatResponseCategory.PogStuff
		NeuroLogic.NeuroActionCategory.AboutHerself: return ChatResponseCategory.AboutHerself
		NeuroLogic.NeuroActionCategory.InterestingStuff: return ChatResponseCategory.InterestingStuff
		NeuroLogic.NeuroActionCategory.Joke: return ChatResponseCategory.Joke
		NeuroLogic.NeuroActionCategory.Story: return ChatResponseCategory.Story
		NeuroLogic.NeuroActionCategory.CorpaMoment: return ChatResponseCategory.CorpaMoment
		NeuroLogic.NeuroActionCategory.Question: return ChatResponseCategory.Question
		NeuroLogic.NeuroActionCategory.Answer: return ChatResponseCategory.Answer
		NeuroLogic.NeuroActionCategory.HiChat: return ChatResponseCategory.HiChat
	
	return ChatResponseCategory.None
