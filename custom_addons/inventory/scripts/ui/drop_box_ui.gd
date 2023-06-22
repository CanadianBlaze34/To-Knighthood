class_name DropBoxUI extends NinePatchRect

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var button_theme := preload("res://resources/inventory/button_theme.tres")

const button_height : int = 23
const additional_row_height : int = 4


func make_buttons(names_and_functions: Dictionary) -> void:
	
	_remove_previous_buttons()
	
	var buttons : int = names_and_functions.size()
	# set container size
	size.y = custom_minimum_size.y + (buttons - 1) * (additional_row_height + button_height)

	# make x number of buttons
	for button_name in names_and_functions:
		var button_function : Callable = names_and_functions[button_name]
		var button := Button.new()
		button.name = button_name
		button.text = button_name
		button.pressed.connect(button_function)
		button.theme = button_theme
		v_box_container.add_child(button)

func _remove_previous_buttons() -> void:
	for child in v_box_container.get_children():
		child.queue_free()
		v_box_container.remove_child(child)
	
