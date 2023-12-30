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
