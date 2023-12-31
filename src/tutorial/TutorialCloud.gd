extends Control

@export var machine_name : String = "MACHINE_NAME" 
@export var machine_desc : String = "MACHINE_DESC" 

func _ready():
	$Panel/VBoxContainer/Name.text = machine_name
	$Panel/VBoxContainer/Desc.text = machine_desc

func _is_mouse_inside() -> bool:
	var rect = get_global_rect()
	var mouse_position = get_global_mouse_position()
	return rect.has_point(mouse_position)

func _process(delta):
	if visible == false or is_visible_in_tree() == false or modulate.a == 0:
		$Panel.visible = false
		return
	
	var hovered := _is_mouse_inside()
	$Sprite2D.frame = 1 if hovered else 0
	
	if hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$Panel.visible = true
	else:
		$Panel.visible = false
