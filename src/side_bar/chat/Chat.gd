extends Control

const chat_entry_tscn := preload("res://src/side_bar/chat/ChatEntry.tscn")

@export var chat_list : VBoxContainer

func add_test_entry() -> void:
	var test_user := ChatLogic.UserData.new()
	test_user.badge = Database.UserBadge.Sub1
	test_user.username = "TestUser_" + str(randi() % 100)
	test_user.color = Color.from_hsv(randf(), 0.7, 0.9)
	
	var test_chat_entry := ChatLogic.ChatEntryData.new()
	test_chat_entry.user_data = test_user
	test_chat_entry.content = [
		ChatLogic.Msg.new("That was sick!"),
		ChatLogic.Emoji.new(Database.EmojiType.Pog),
		ChatLogic.Msg.new("That was sick!"),
		ChatLogic.Emoji.new(Database.EmojiType.Kekw)
	]

	Game.get_chat_logic().add_chat_entry(test_chat_entry)

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_Q:
			add_test_entry()

func _ready():
	for entry in chat_list.get_children():
		entry.visible = false
	Game.get_chat_logic().chat_entry_added.connect(_on_chat_entry_added)

func _on_chat_entry_added(new_entry : ChatLogic.ChatEntryData) -> void:
	if new_entry == null:
		for entry in chat_list.get_children():
			entry.visible = false
		return

	_reload_chat()
	#var entry := chat_entry_tscn.instantiate()
	#entry.setup_entry(new_entry)
	#chat_list.add_child(entry)
	
func _reload_chat():
	var all_entries := Game.get_chat_logic().get_chat_entries()
	
	var entry_instance_idx = chat_list.get_child_count() - 1
	var entry_data_idx = all_entries.size() - 1

	while entry_data_idx >= 0 and entry_instance_idx >= 0:
		var entry_data := all_entries[entry_data_idx]
		var entry_instance : ChatEntry = chat_list.get_child(entry_instance_idx)
		entry_instance.visible = true
		entry_instance.setup_entry(entry_data)
		entry_data_idx -= 1
		entry_instance_idx -= 1
		
	
	
