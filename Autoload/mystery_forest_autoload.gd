class_name _MysteryForestAutoload extends Node

var _monk_1_initial_talk : SaveBool


signal monk_1_initial_talk_signal


# functions --------------------------------------------------------------------

func _ready() -> void:
	SaveLoad.save_changed.connect(_on_save_change)

# SaveVariable -----------------------------------------------------------------

func _on_save_change() -> void:
	# if ANY of the SaveVariables are set, delete them all
	# reset all variables if this function is called again
	if _monk_1_initial_talk:
		_free_save_variables()
	# Autoload Script
	# Called once, when the program starts
	_monk_1_initial_talk = SaveBool.new()
	_monk_1_initial_talk.init("initial_talk_monk_1", false)


func _free_save_variables() -> void:
	_monk_1_initial_talk.delete()


func _exit_tree() -> void:
	# if ANY of the SaveVariables are set, delete them all
	if _monk_1_initial_talk:
		_free_save_variables()

# Monk 1 -----------------------------------------------------------------------

func initial_talk_with_monk_1() -> void:
	_monk_1_initial_talk.value = true
	monk_1_initial_talk_signal.emit()


func has_initially_talked_with_monk_1() -> bool:
	return _monk_1_initial_talk.value

