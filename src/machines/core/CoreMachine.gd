extends Node2D


@export var sub_queue : NeuroActionQueue
@export var chat_queue : NeuroActionQueue

@export var handle_sub_btn : Button
@export var handle_chat_btn : Button


signal new_message(msg_type: NeuroAction.Type)
signal say_message(msg_type: NeuroAction.Type)


func _input(event):
	if event is InputEventKey and not event.echo and event.pressed:
		match event.keycode:
			KEY_1:
				add_sub_message()
			KEY_2:
				add_chat_message()
			KEY_3:
				dequeue_sub_message()
			KEY_4:
				dequeue_chat_message()


func _ready():
	handle_sub_btn.pressed.connect(dequeue_sub_message)
	handle_chat_btn.pressed.connect(dequeue_chat_message)


func add_sub_message() -> void:
	var msg_type := NeuroAction.Type.SUB
	sub_queue.add_message(msg_type)
	new_message.emit(msg_type)


func add_chat_message() -> void:
	var msg_type := NeuroAction.Type.CHAT_NEUTRAL
	chat_queue.add_message(msg_type)
	new_message.emit(msg_type)


func dequeue_sub_message() -> void:

	say_message.emit(sub_queue.dequeue_message())


func dequeue_chat_message() -> void:
	say_message.emit(chat_queue.dequeue_message())