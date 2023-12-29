extends Node2D


@export var bell: Grabbable
@export var ding_threshold: float

@export var sleepy_lower_amount: float

var _prev_bell_angular_velocity: float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var bell_angular_velocity = bell.angular_velocity * delta
    var vel_delta = bell_angular_velocity - _prev_bell_angular_velocity

    if abs(vel_delta) > ding_threshold:
        ding()
    
    _prev_bell_angular_velocity = bell_angular_velocity


func ding():
    print("DING")
    print("Lower sleepy power by %s" % sleepy_lower_amount)
