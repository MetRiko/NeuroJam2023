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
	ChatLogic.ChatResponseCategory.Karaoke: [
		[ ChatLogic.Msg.new("NeuroCheer") ]
	],
	ChatLogic.ChatResponseCategory.Bedge: [
		[ ChatLogic.Msg.new("Bedge") ]
	],
	ChatLogic.ChatResponseCategory.Ignored: [
		[ ChatLogic.Msg.new("DonoWall") ],
		[ ChatLogic.Msg.new("PauseSama") ]
	],
	ChatLogic.ChatResponseCategory.Filtered: [
		[ ChatLogic.Msg.new("1984") ]
	],
	ChatLogic.ChatResponseCategory.Tutel: [
		[ ChatLogic.Msg.new("Tutel") ]
	],
	ChatLogic.ChatResponseCategory.BadWords: [
		[ ChatLogic.Msg.new("D:") ],
		[ ChatLogic.Msg.new("FrickU") ]
	],
	ChatLogic.ChatResponseCategory.Timeout: [
		[ ChatLogic.Msg.new("RIPBOZO") ]
	],
	ChatLogic.ChatResponseCategory.Schizo: [
		[ ChatLogic.Msg.new("SCHIZO") ]
	],
	ChatLogic.ChatResponseCategory.Lovely_1: [
		[ ChatLogic.Msg.new("<3") ]
	],
	ChatLogic.ChatResponseCategory.Lovely_2: [
		[ ChatLogic.Msg.new("<3 <3") ],
		[ ChatLogic.Msg.new("SoCute") ]
	],
	ChatLogic.ChatResponseCategory.Lovely_3: [
		[ ChatLogic.Msg.new("<3 <3 <3") ]
	],
	ChatLogic.ChatResponseCategory.Evil_1: [
		[ ChatLogic.Msg.new("D:") ]
	],
	ChatLogic.ChatResponseCategory.Evil_2: [
		[ ChatLogic.Msg.new("D: D:") ]
	],
	ChatLogic.ChatResponseCategory.Evil_3: [
		[ ChatLogic.Msg.new("BAND") ]
	],
	ChatLogic.ChatResponseCategory.PogStuff: [
		[ ChatLogic.Msg.new("Pog") ]
	],
	ChatLogic.ChatResponseCategory.AboutHerself: [
		[ ChatLogic.Msg.new("GIGANEURO") ]
	],
	ChatLogic.ChatResponseCategory.IterestingStuff: [
		[ ChatLogic.Msg.new("NOTED") ]
	],
	ChatLogic.ChatResponseCategory.Joke: [
		[ ChatLogic.Msg.new("ICANT") ],
		[ ChatLogic.Msg.new("GOODONE") ]
	],
	ChatLogic.ChatResponseCategory.Story: [
		[ ChatLogic.Msg.new("FeelsStrongMan") ]
	],
	ChatLogic.ChatResponseCategory.CorpaMoment: [
		[ ChatLogic.Msg.new("Corpa") ]
	],
	ChatLogic.ChatResponseCategory.Question: [
		[ ChatLogic.Msg.new("YES") ],
		[ ChatLogic.Msg.new("NO") ]
	],
	ChatLogic.ChatResponseCategory.Answer: [
		[ ChatLogic.Msg.new("NOTED") ],
		[ ChatLogic.Msg.new("GOODONE") ]
	],
	ChatLogic.ChatResponseCategory.HiChat: [
		[ ChatLogic.Msg.new("Hi Neuro!") ]
	]
}
