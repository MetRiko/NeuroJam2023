extends MarginContainer
class_name ChatEntry

@export var label : RichTextLabel
@export var badge : TextureRect

func setup_entry(chat_entry : ChatLogic.ChatEntryData):
	var has_badge := chat_entry.user_data.badge != Database.UserBadge.None
	badge.visible = has_badge
	if has_badge:
		badge.texture = Database.user_badges[chat_entry.user_data.badge]
	var indent_text := "     " if has_badge else ""
	
	var msg_content := " ".join(chat_entry.content.map(func(c): return c.get_text()))
	var color_str := chat_entry.user_data.color.to_html(false)
	var username := chat_entry.user_data.username
	var final_msg := "%s[b][color=%s]%s[/color][/b]: %s" % [indent_text, color_str, username, msg_content]
	label.text = final_msg
	
