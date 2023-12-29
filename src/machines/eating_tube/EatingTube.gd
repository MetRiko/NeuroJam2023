extends Node2D

@onready var eat_trigger_area: Area2D = $EatTrigger

@export var anger_lower_amount: float
@export var schizo_lower_amount: float


# Called when the node enters the scene tree for the first time.
func _ready():
    eat_trigger_area.body_entered.connect(_on_eat)


func _on_eat(body):
    if body is SchizoPill:
        eat_schizo_pill()
        body.queue_free()
    elif body is Cookie:
        eat_cookie()
        body.queue_free()
    


func eat_schizo_pill():
    print("Lower schizo by %s" % schizo_lower_amount)


func eat_cookie():
    print("Lower anger by %s" % anger_lower_amount)
