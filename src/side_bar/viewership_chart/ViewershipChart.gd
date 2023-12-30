extends Control

@export var line_rect : ColorRect
@export var line : Line2D
@export var viewers_amount_label : Label

const max_points_count := 100
var viewership_list : Array[int] = []
var viewership_start_idx := 0

func get_left_side_point() -> Vector2:
	var rect := line_rect.get_rect()
	return rect.size * Vector2(0.0, 0.5)

func get_right_side_point() -> Vector2:
	var rect := line_rect.get_rect()
	return rect.size * Vector2(1.0, 0.5)

func _ready():
	viewers_amount_label.text = str(0)
	Game.get_viewership_logic().viewership_changed.connect(_on_viewership_changed)

func _on_viewership_changed(viewership : int) -> void:
	push_viewership(viewership)
	_update_chart()
	viewers_amount_label.text = str(viewership)
	
func push_viewership(viewership : int) -> void:
	if viewership_list.size() < max_points_count:
		viewership_list.append(viewership)
	else:
		viewership_list[viewership_start_idx] = viewership
		viewership_start_idx = (viewership_start_idx + 1) % max_points_count

func _update_chart():
	var new_points : Array[Vector2] = []
	if viewership_list.size() > 1:

		var left_point := get_left_side_point()
		var right_point := get_right_side_point()

		var points_count := viewership_list.size()
		var max_viewership : int = viewership_list.max()
		var min_viewership : int = viewership_list.min()
		var y_axis_max := line_rect.get_rect().size.y

		for i : int in points_count:
			var idx := (i + viewership_start_idx) % max_points_count
			var viewership := viewership_list[idx]
			var horizontal_factor := float(i) / (max_points_count - 1)

			var point := left_point.lerp(right_point, horizontal_factor)

			var vertical_factor := inverse_lerp(min_viewership, max_viewership, viewership)
			point.y -= (vertical_factor - 0.5) * y_axis_max

			new_points.append(point)
	
	line.points = new_points

