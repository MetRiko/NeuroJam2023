extends Node2D

@export var donowall_lower_amount: float


@onready var _handle: FlusherHandle = $Handle


# Called when the node enters the scene tree for the first time.
func _ready():
    _handle.flush.connect(_on_flush)


func _on_flush():
    print("Lower donowall by %s" % donowall_lower_amount)
