extends RigidBody2D


@onready var area: Area2D = $Area2D
@export var position_threshold: float
@export var launch_force: float
@export var launch_force_time: float

@onready var _launch_timer: Timer = $LaunchTimer

var launching := false
var launch_stop_threshold


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

	launch_stop_threshold = position.y + 10


func _on_body_entered(body):
	# print("Enter %s" % body)
	pass


func _on_body_exited(body):
	# print("Exit %s" % body)
	if body is Player:
		_launch()


func _launch():
	_launch_timer.start(launch_force_time)
	launching = true
	await _launch_timer.timeout
	launching = false
	


func _physics_process(delta):
	if launching:
		apply_central_force(Vector2.UP * launch_force)
		if position.y < launch_stop_threshold:
			launching = false
