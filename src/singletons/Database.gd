extends Node

enum EmojiType {
	None, Pog, Kekw
}

var emojis := {
	EmojiType.Pog: "res://res/7tv_emojis/Pog.webp",
	EmojiType.Kekw: "res://res/7tv_emojis/KEKW.webp"
}

enum UserBadge {
	None, Mod, Vip, Sub1, Sub2, Sub3
}

const user_badges := {
	UserBadge.Mod: preload("res://res/badges/mod.png"),
	UserBadge.Vip: preload("res://res/badges/vip.png"),
	UserBadge.Sub1: preload("res://res/badges/sub1.png"),
	UserBadge.Sub2: preload("res://res/badges/sub2.png"),
	UserBadge.Sub3: preload("res://res/badges/sub3.png")
}

var chat_answers := {
	"slept": [
		[ ChatLogic.Msg.new("Bedge") ]
	],
	"ignored": [
		[ ChatLogic.Msg.new("DonoWall") ],
		[ ChatLogic.Msg.new("PauseSama") ]
	],
	"filtered": [
		[ ChatLogic.Msg.new("1984") ]
	],
	"tutel": [
		[ ChatLogic.Msg.new("Tutel") ]
	],
	"bad_words": [
		[ ChatLogic.Msg.new("D:") ],
		[ ChatLogic.Msg.new("FrickU") ]
	],
	"timeout": [
		[ ChatLogic.Msg.new("RIPBOZO") ]
	],
	"schizo": [
		[ ChatLogic.Msg.new("SCHIZO") ]
	],
	"lovely_1": [
		[ ChatLogic.Msg.new("<3") ]
	],
	"lovely_2": [
		[ ChatLogic.Msg.new("<3 <3") ],
		[ ChatLogic.Msg.new("SoCute") ]
	],
	"lovely_3": [
		[ ChatLogic.Msg.new("<3 <3 <3") ]
	],
	"evil_1": [
		[ ChatLogic.Msg.new("D:") ]
	],
	"evil_2": [
		[ ChatLogic.Msg.new("D: D:") ]
	],
	"evil_3": [
		[ ChatLogic.Msg.new("BAND") ]
	],
	"pog_stuff": [
		[ ChatLogic.Msg.new("Pog") ]
	],
	"about_herself": [
		[ ChatLogic.Msg.new("GIGANEURO") ]
	],
	"iteresting_stuff": [
		[ ChatLogic.Msg.new("NOTED") ]
	],
	"joke": [
		[ ChatLogic.Msg.new("ICANT") ],
		[ ChatLogic.Msg.new("GOODONE") ]
	],
	"story": [
		[ ChatLogic.Msg.new("FeelsStrongMan") ]
	],
	"corpa_moment": [
		[ ChatLogic.Msg.new("Corpa") ]
	],
	"question": [
		[ ChatLogic.Msg.new("YES") ],
		[ ChatLogic.Msg.new("NO") ]
	],
	"answer": [
		[ ChatLogic.Msg.new("NOTED") ],
		[ ChatLogic.Msg.new("GOODONE") ]
	],
	"hi_chat": [
		[ ChatLogic.Msg.new("Hi Neuro!") ]
	]
}