class_name TitleMenu extends Control

@onready var load_button: Button = $MainMenu/Load
@onready var load_menu: Control = $LoadMenu
@onready var main_menu: VBoxContainer = $MainMenu
@onready var saved_games_button_container: GridContainer = $LoadMenu/SavedGamesButtonContainer

@export var button_theme : Theme 


func _ready() -> void:
	_show_main_menu()
	_edit_load_button()


func _edit_load_button() -> void:
	# disable the load button if there are no saved games to load
	
	# number of saved games
	var saved_games_quantity : int = SaveSystem.get_save_count()
	# no saved games
	if saved_games_quantity == 0:
		# can't load any saved games
		load_button.disabled = true


func _load_main_scene() -> void:
	
	# remove this scene
	queue_free()
	
	# add the main scene
	var main_scene := preload("res://scenes/main.tscn").instantiate()
	get_parent().call_deferred("add_child", main_scene)
	get_tree().call_deferred("set_current_scene", main_scene)


func _adjust_load_menus_saved_games_columns() -> void:
	var saved_games_quantity : int = SaveSystem.get_save_count()
	const saved_games_per_columns : int = 3
	
	@warning_ignore("integer_division")
	# There should be a minimum of 1 column
	# saved_games_per_columns + 1 adds another column once saved_games_quantity
	# has reached over the wanted saved_games_per_columns
	saved_games_button_container.columns = saved_games_quantity / (saved_games_per_columns + 1) + 1


func _make_load_button(saved_game_name: String) -> Button:
	var button := Button.new()
	button.theme = button_theme
	button.name = saved_game_name
	button.text = saved_game_name
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	button.set_button_mask(MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT)
	
	button.gui_input.connect(_on_load_button_saved_game_gui_input.bind(saved_game_name))
	
	return button


func _show_main_menu() -> void:
	main_menu.show()
	load_menu.hide()


func _show_load_menu() -> void:
	load_menu.show()
	main_menu.hide()


func _remove_previously_loaded_saved_games_buttons() -> void:
	for child in saved_games_button_container.get_children():
		saved_games_button_container.remove_child(child)
		child.queue_free()


# Signals ----------------------------------------------------------------------


func _on_load_button_saved_game_gui_input(event : InputEvent,
		saved_game_name: String) -> void:
	
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			
			MOUSE_BUTTON_LEFT:
				print("Loading %s." % [saved_game_name])
				SaveLoad.set_save(saved_game_name)
				_load_main_scene()
				
			MOUSE_BUTTON_RIGHT:
				print("deleting %s." % [saved_game_name])
				SaveLoad.delete_save(saved_game_name)
				_adjust_load_menus_saved_games_columns()
				_edit_load_button()
				if load_button.disabled:
					_show_main_menu()


func _on_new_pressed() -> void:
	SaveLoad.new_save_auto()
	_load_main_scene()


func _on_load_pressed() -> void:
	
	_adjust_load_menus_saved_games_columns()
	
	# add saved_games_names as buttons that'll load the save once clicked on
	var saved_games_names : PackedStringArray = SaveSystem.get_all_saves()
	for saved_games_name in saved_games_names:
		var button := _make_load_button(saved_games_name)
		saved_games_button_container.add_child(button)
	
	_show_load_menu()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_show_main_menu()
	_remove_previously_loaded_saved_games_buttons()


