extends Node
class_name ViewershipLogic

signal viewership_changed(new_viewership : int)

var current_viewership := 1000
var stream_time := 0.0

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)

func _process(delta):
	stream_time += delta
	
func _on_timer_timeout():
	_update_viewership()
	
func _update_viewership():
	var delta_vierwership := sin(stream_time * 0.5)
	delta_vierwership *= randi_range(10, 100)
	
	var delta_vierwership_2 := sin(stream_time * 1.0)
	delta_vierwership_2 *= randi_range(1, 50)
	
	current_viewership += delta_vierwership + delta_vierwership_2
	# print(current_viewership, ' <-', int(delta_vierwership), ' & ', int(delta_vierwership_2)) 
	
	viewership_changed.emit(current_viewership)
