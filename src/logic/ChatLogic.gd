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

func get_chat_entries() -> Array[ChatEntryData]:
	return chat_entries 

func add_chat_entry(entry : ChatEntryData):
	chat_entries.push_back(entry)
	chat_entry_added.emit(entry)

var current_neuro_action : NeuroFinalAction = null

func _ready():
	randomize()
	Game.get_neuro_logic().neuro_action_started.connect(_on_neuro_action_started)

func _on_neuro_action_started(neuro_action : NeuroFinalAction):
	current_neuro_action = neuro_action

var chat_cooldown_time := 0.0

func _process(delta):
	chat_cooldown_time -= delta
	if chat_cooldown_time <= 0.0:
		chat_cooldown_time = randf_range(0.2, 3.5) * 60.0
		_generate_matching_chat_entry()

func _queue_chat_answer(answer_id : String):
	var test_user := ChatLogic.UserData.new()
	test_user.badge = Database.UserBadge.Sub1
	test_user.username = "TestUser_" + str(randi() % 100)
	test_user.color = Color.from_hsv(randf(), 0.7, 0.9)

	var chat_entry := ChatLogic.ChatEntryData.new()
	chat_entry.user_data = test_user
	var possible_answers : Array = Database.chat_answers[answer_id]
	chat_entry.content = possible_answers.pick_random()

	add_chat_entry(chat_entry)

func _generate_matching_chat_entry():
	# todo: karaoke

	match current_neuro_action.action_oopsie:
		NeuroActionOopsie.Slept:
			_queue_chat_answer("bedge")
			return
		NeuroActionOopsie.Ignored:
			_queue_chat_answer("ignored")
			return
		NeuroActionOopsie.Filtered:
			_queue_chat_answer("filtered")
			return

	var post_additional_comment_instead := randf() < 0.2
	if post_additional_comment_instead:
		var comment_types := []

		if current_neuro_action.is_tutel_reciver:
			comment_types.append(1)
			
		if current_neuro_action.contains_bad_words:
			comment_types.append(2)
	
		if current_neuro_action.neuro_timeouted_someone:
			comment_types.append(3)

		if comment_types.size() > 0:
			match comment_types.pick_random():
				1:	# is_tutel_reciver -> Tutel
					_queue_chat_answer("tutel")
				2:	# contains_bad_words -> D:
					_queue_chat_answer("bad_words")
				3:	# neuro_timeouted_someone -> RIPBOZO
					_queue_chat_answer("timeout")
			return

	# schizo_factor
	if randf() < current_neuro_action.schizo_factor:
		_queue_chat_answer("schizo")
		return

	# pick reaction to intention
	var intention_factor := absf(current_neuro_action.intention)
	if randf() < intention_factor:
		var intention_chance := randf() * intention_factor
		var is_lovely := current_neuro_action.intention > 0
		if intention_chance >= 0.7: # lvl 3
			_queue_chat_answer("lovely_3" if is_lovely else "evil_3")
			return
		elif intention_chance >= 0.4: # lvl 2
			_queue_chat_answer("lovely_2" if is_lovely else "evil_2")
			return
		elif intention_chance >= 0.15: # lvl 1
			_queue_chat_answer("lovely_1" if is_lovely else "evil_1")
			return

	match current_neuro_action.category:
		NeuroActionCategory.PogStuff:
			_queue_chat_answer("pog_stuff")
		NeuroActionCategory.AboutHerself:
			_queue_chat_answer("about_herself")
		NeuroActionCategory.IterestingStuff:
			_queue_chat_answer("iteresting_stuff")
		NeuroActionCategory.Joke:
			_queue_chat_answer("joke")
		NeuroActionCategory.Story:
			_queue_chat_answer("story")
		NeuroActionCategory.CorpaMoment:
			_queue_chat_answer("corpa_moment")
		NeuroActionCategory.Question:
			_queue_chat_answer("question")
		NeuroActionCategory.Answer:
			_queue_chat_answer("answer")
		NeuroActionCategory.HiChat:
			_queue_chat_answer("hi_chat")

# enum NeuroActionOrigin {
# 	Neuro, Chat, Vedal, Donation
# }

# enum NeuroActionCategory {
# 	PogStuff, AboutHerself, IterestingStuff, Joke, Story, CorpaMoment, Question, Answer, HiChat
# }

# enum NeuroActionOopsie {
# 	None, Filtered, Ignored, Slept
# }

# class NeuroPlannedAction:
# 	var origin : NeuroActionOrigin # Neuro, Chat, Vedal, Donation
# 	var category : NeuroActionCategory # PogStuff, AboutHerself, IterestingStuff, Joke, Story, CorpaMoment, Question, Answer

# class NeuroFinalAction extends NeuroPlannedAction:
# 	# var message : String # will be getter, depends on category
# 	var intention : float  # evil, neutral, love   -1.0..1.0
# 	var contains_bad_words : bool
# 	var action_oopsie : NeuroActionOopsie
# 	var schizo_factor : float
# 	var neuro_timeouted_someone : bool
# 	var is_tutel_reciver : bool