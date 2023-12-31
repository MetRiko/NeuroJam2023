extends Node

enum EmojiType {
	None, 
	Pog, 
	Kekw,
	NeuroCheer, 
	Bedge, 
	DonoWall, 
	PauseSama, 
	Filtered1984, 
	Tutel, 
	Gasp, 
	FrickU, 
	RipBozo, 
	Schizo, 
	NeuroPossessed,
	Heart,
	SoCute,
	Huh,
	Uhh,
	Band,
	Poggers,
	NeuroPoggers,
	GigaNeuro,
	Noted,
	Hmm,
	ICant,
	GoodOne,
	FeelsStrongMan,
	Corpa,
	Yes,
	No,
	Mhm,
	Clap,
	OSeven
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
		[ ChatLogic.Msg.new("D: Wording") ],
		[ ChatLogic.Msg.new("D: F word") ],
		[ ChatLogic.Msg.new("D:") ],
		[ ChatLogic.Msg.new("FrickU") ]
	],
	ChatLogic.ChatResponseCategory.Timeout: [
		[ ChatLogic.Msg.new("RIPBOZO") ]
	],
	ChatLogic.ChatResponseCategory.Schizo: [
		[ ChatLogic.Msg.new("SCHIZO") ],
		[ ChatLogic.Msg.new("NeuroPossessed") ]
	],
	ChatLogic.ChatResponseCategory.Lovely_1: [
		[ ChatLogic.Msg.new("<3") ]
	],
	ChatLogic.ChatResponseCategory.Lovely_2: [
		[ ChatLogic.Msg.new("<3 <3") ],
		[ ChatLogic.Msg.new("SoCute") ]
	],
	ChatLogic.ChatResponseCategory.Lovely_3: [
		[ ChatLogic.Msg.new("<3 <3 <3") ],
		[ ChatLogic.Msg.new("HUH") ],
		[ ChatLogic.Msg.new("uhh") ]
	],
	ChatLogic.ChatResponseCategory.Evil_1: [
		[ ChatLogic.Msg.new("D:") ]
	],
	ChatLogic.ChatResponseCategory.Evil_2: [
		[ ChatLogic.Msg.new("D: D:") ]
	],
	ChatLogic.ChatResponseCategory.Evil_3: [
		[ ChatLogic.Msg.new("D: D: D:") ],
		[ ChatLogic.Msg.new("BAND") ]
	],
	ChatLogic.ChatResponseCategory.PogStuff: [
		[ ChatLogic.Msg.new("Pog") ],
		[ ChatLogic.Msg.new("POGGERS") ],
		[ ChatLogic.Msg.new("neuroPoggers") ]
	],
	ChatLogic.ChatResponseCategory.AboutHerself: [
		[ ChatLogic.Msg.new("GIGANEURO") ]
	],
	ChatLogic.ChatResponseCategory.InterestingStuff: [
		[ ChatLogic.Msg.new("NOTED") ],
		[ ChatLogic.Msg.new("Hmm") ]
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
		[ ChatLogic.Msg.new("mhm") ]
	],
	ChatLogic.ChatResponseCategory.HiChat: [
		[ ChatLogic.Msg.new("Hi Neuro!") ]
	],
	ChatLogic.ChatResponseCategory.HiVedal: [
		[ ChatLogic.Msg.new("Hi Vedal!") ],
		[ ChatLogic.Msg.new("Tutel") ]
	],
	ChatLogic.ChatResponseCategory.BombDefused: [
		[ ChatLogic.Msg.new("Pog!") ],
		[ ChatLogic.Msg.new("Clap! Clap!") ],
		[ ChatLogic.Msg.new("She did it!") ]
	],
	ChatLogic.ChatResponseCategory.BombExploded: [
		[ ChatLogic.Msg.new("o7") ]
	],
	ChatLogic.ChatResponseCategory.DefusingBomb: [
		[ ChatLogic.Msg.new("You can do it Neuro!") ],
		[ ChatLogic.Msg.new("NeuroCheer") ]
	]
}
