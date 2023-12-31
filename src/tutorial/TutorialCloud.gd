extends Control

@export var panel : Control

func _is_mouse_inside() -> bool:
	var rect = get_global_rect()
	var mouse_position = get_global_mouse_position()
	return rect.has_point(mouse_position)

func _process(delta):
	if visible == false or is_visible_in_tree() == false or modulate.a == 0:
		panel.visible = false
		return
	
	var hovered := _is_mouse_inside()
	$Sprite2D.frame = 1 if hovered else 0
	
	if hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		panel.visible = true
	else:
		panel.visible = false
