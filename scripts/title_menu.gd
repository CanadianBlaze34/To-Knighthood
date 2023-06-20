class_name TitleMenu extends Control

@onready var load_: Button = $MainMenu/Load

@onready var load_menu: Control = $LoadMenu
@onready var main_menu: VBoxContainer = $MainMenu

@onready var saves: GridContainer = $LoadMenu/Saves

#@onready var main_scene_res : PackedScene = preload("res://scenes/main.tscn")
@onready var main_scene_res : PackedScene = preload("res://scenes/main_2.tscn")
@export var button_theme : Theme 


func _ready() -> void:
	_show_main_menu()
	_disable_load_button()


func _disable_load_button() -> bool:
	# number of saved games
	var save_count : int = SaveSystem.get_save_count()
	# no saved games
	if not save_count:
		# can't load any saved games
		load_.disabled = true
	
	return load_.disabled


func _load_main_scene() -> void:
	
	# remove the title scene
	call_deferred("queue_free")
	
	# add the main scene
	var main_scene := main_scene_res.instantiate()
	get_parent().call_deferred("add_child", main_scene)
	get_tree().call_deferred("set_current_scene", main_scene)


func _on_new_pressed() -> void:
	SaveLoad.new_save_auto()
	_load_main_scene()


func _set_load_menu_columns() -> void:
	var save_count : int = SaveSystem.get_save_count()
	const saves_per_columns : int = 3
	
	@warning_ignore("integer_division")
	saves.columns = save_count / (saves_per_columns + 1) + 1


func _make_load_button(save_name: String) -> Button:
	var button := Button.new()
	button.theme = button_theme
	button.name = save_name
	button.text = save_name
	button.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
	
	button.gui_input.connect(
		func (event : InputEvent):
			if event is InputEventMouseButton and event.pressed:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						print("Loading %s." % [save_name])
						SaveLoad.set_save(save_name)
						_load_main_scene()
					MOUSE_BUTTON_RIGHT:
						print("deleting %s." % [save_name])
						SaveLoad.delete_save(save_name)
						button.queue_free()
						_set_load_menu_columns()
						if _disable_load_button():
							_show_main_menu()
	)
	return button


func _on_load_pressed() -> void:
	
	var save_names : PackedStringArray = SaveSystem.get_all_saves()
	_set_load_menu_columns()
	
	for child in saves.get_children():
		saves.remove_child(child)
	
	# add buttons as saves
	for save_name in save_names:
		var button := _make_load_button(save_name)
		saves.add_child(button)
	
	_show_load_menu()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_show_main_menu()


func _show_main_menu() -> void:
	main_menu.show()
	load_menu.hide()


func _show_load_menu() -> void:
	load_menu.show()
	main_menu.hide()




