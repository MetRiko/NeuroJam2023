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
