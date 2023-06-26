class_name Main extends Node2D

@onready var player: Player = $Player
var active_scene : SaveString

signal give_player_item(item : ItemData, quantity : int)

func _ready() -> void:
	
	Village1Autoload.gave_parents_sword.connect(_on_give_player_item)
	
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
	var loaded_scene : Node = load(active_scene.value).instantiate()
	PickupableItemTrackerAutoload.set_scene(loaded_scene)
	
	call_deferred("add_child", loaded_scene)
	print("Main._ready() loading '%s' scene." % [active_scene.value])
	
	loaded_scene.ready.connect(_on_new_scene_ready.bind(loaded_scene))


func _free_save_variables() -> void:
	active_scene.delete()


func _exit_tree() -> void:
	_free_save_variables()


# ----------------------------------------------------------------

func _on_give_player_item(item : ItemData, quantity : int) -> void:
	player.add_item(item, quantity)

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
	if node.is_in_group("active_scene") and node.get_scene_file_path() != active_scene.value:
		active_scene.value = node.get_scene_file_path()
		PickupableItemTrackerAutoload.set_scene(node)
		node.ready.connect(_on_new_scene_ready.bind(node))


func _on_new_scene_ready(new_scene : Node) -> void:
	print("Main::_on_new_scene_ready")
	PickupableItemTrackerAutoload.on_scene_ready(new_scene)
	# SceneTransition._on_body_entered() will call player.disable_walking()
	player.enable_walking()




