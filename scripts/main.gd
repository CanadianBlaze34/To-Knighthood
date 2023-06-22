class_name Main extends Node2D

@onready var player: Player = $Player
var active_scene : SaveString


func _ready() -> void:
	
	_set_save_variables()
	
	SaveLoad.load_variables()
	
	# load all the variables after the 'SaveLoad.load_variables()' function is called
#	SaveLoad.variables_loaded_from_file.connect(_on_variables_loaded_from_file)
	_on_variables_loaded_from_file()


# SaveVariable ----------------------------------------------------------------

func _set_save_variables() -> void:
	active_scene = SaveString.new()
	active_scene.init("scene", "res://scenes/player_room.tscn")


func _on_variables_loaded_from_file() -> void:
	# load the scene after it is loaded from the file
	# if it isn't loaded from the file, the default scene will be saved to the file
	# and the default scene will be loaded
	var loaded_scene = load(active_scene.value).instantiate()
	call_deferred("add_child", loaded_scene)
	print("Main._ready() loading '%s' scene." % [active_scene.value])


func _free_save_variables() -> void:
	active_scene.delete()


func _exit_tree() -> void:
	_free_save_variables()


# ----------------------------------------------------------------

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("title_menu"):
		_goto_title_menu()


func _goto_title_menu() -> void:
	var title_menu = load("res://scenes/title_menu.tscn").instantiate()
	queue_free()
	get_parent().call_deferred("add_child", title_menu)


func _on_child_entered_tree(node: Node) -> void:
	# _ready is called after this
	# will set when initializing main node
	if node.is_in_group("active_scene"):
		active_scene.value = node.get_scene_file_path()






