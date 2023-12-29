extends Node
class_name ChatLogic

signal chat_entry_added(entry : ChatEntryData)

enum NeuroActionOrigin {
    Neuro, Chat, Vedal, Donation
}

enum NeuroActionCategory {
    PogStuff, AboutHerself, InterestingStuff, Joke, Story, CorpaMoment, Question, Answer, HiChat
}

enum NeuroActionOopsie {
    None, Filtered, Ignored, Slept
}

class NeuroPlannedAction:
    var origin : NeuroActionOrigin # Neuro, Chat, Vedal, Donation
    var category : NeuroActionCategory # PogStuff, AboutHerself, InterestingStuff, Joke, Story, CorpaMoment, Question, Answer

class NeuroFinalAction extends NeuroPlannedAction:
    # var message : String # will be getter, depends on category
    var intention : float  # evil, neutral, love   -1.0..1.0
    var contains_bad_words : bool
    var action_oopsie : NeuroActionOopsie
    var schizo_factor : float
    var neuro_timeouted_someone : bool
    var is_tutel_receiver : bool


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
