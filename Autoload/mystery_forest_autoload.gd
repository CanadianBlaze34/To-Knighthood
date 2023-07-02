class_name _MysteryForestAutoload extends Node

var _monk_1_initial_talk : SaveBool
var _monk_1_quest_complete : SaveBool

var _first_time_talking_with_monk_2 : SaveBool
var _monk_2_quest_complete : SaveBool
const raccoons_to_pet : int = 5

var _first_time_talking_with_monk_3 : SaveBool
var _monk_3_quest_complete : SaveBool

var _first_time_talking_with_monk_4 : SaveBool


# This is set by Main
var player : Player = null

signal monk_1_initial_talk_signal
signal monk_1_quest_complete

signal talked_with_monk_2_for_the_first_time_signal
signal monk_2_quest_complete

signal talked_with_monk_3_for_the_first_time_signal
signal monk_3_quest_complete

signal talked_with_monk_4_for_the_first_time_signal

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
	_monk_1_quest_complete = SaveBool.new()
	_monk_1_quest_complete.init("_monk_1_quest_complete", false)
	
	_first_time_talking_with_monk_2 = SaveBool.new()
	_first_time_talking_with_monk_2.init("_first_time_talking_with_monk_2", false)
	_monk_2_quest_complete = SaveBool.new()
	_monk_2_quest_complete.init("_monk_2_quest_complete", false)
	
	_first_time_talking_with_monk_3 = SaveBool.new()
	_first_time_talking_with_monk_3.init("_first_time_talking_with_monk_3", false)
	_monk_3_quest_complete = SaveBool.new()
	_monk_3_quest_complete.init("_monk_3_quest_complete", false)
	
	_first_time_talking_with_monk_4 = SaveBool.new()
	_first_time_talking_with_monk_4.init("_first_time_talking_with_monk_4", false)


func _free_save_variables() -> void:
	_monk_1_initial_talk.delete()
	_monk_1_quest_complete.delete()

	_first_time_talking_with_monk_2.delete()
	_monk_2_quest_complete.delete()

	_first_time_talking_with_monk_3.delete()
	_monk_3_quest_complete.delete()
	
	_first_time_talking_with_monk_4.delete()


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

func has_monk_1_quest_complete() -> bool:
	return _monk_1_quest_complete.value

func _monk_1_complete_quest() -> void:
	_monk_1_quest_complete.value = true
	monk_1_quest_complete.emit()

# Slime Fish -------------------------------------------------------------------

func player_has_slime_fish() -> bool:
	return player.inventory.has_item(PreloadItemsAutoload.slime_fish)

func remove_slime_fish_from_player_inventory() -> void:
	_monk_1_complete_quest()
	player.inventory.remove_item_quantity(PreloadItemsAutoload.slime_fish, 1)

# Monk 2 -----------------------------------------------------------------------

func is_first_time_talking_with_monk_2() -> bool:
	return _first_time_talking_with_monk_2.value

func talked_with_monk_2_for_the_first_time() -> void:
	_first_time_talking_with_monk_2.value = true
	talked_with_monk_2_for_the_first_time_signal.emit()

func complete_monk_2_quest() -> void:
	_monk_2_quest_complete.value = true
	monk_2_quest_complete.emit()

func has_pet_enough_raccoons() -> bool:
	return StatsAutoload.petted_amount("raccoon") >= raccoons_to_pet

func is_monk_2_quest_completed() -> bool:
	return _monk_2_quest_complete.value

# Monk 3 -----------------------------------------------------------------------

func is_first_time_talking_with_monk_3() -> bool:
	return _first_time_talking_with_monk_3.value

func talked_with_monk_3_for_the_first_time() -> void:
	_first_time_talking_with_monk_3.value = true
	talked_with_monk_3_for_the_first_time_signal.emit()

func complete_monk_3_quest() -> void:
	_monk_3_quest_complete.value = true
	monk_3_quest_complete.emit()


func is_monk_3_quest_completed() -> bool:
	return _monk_3_quest_complete.value


# Monk 4 -----------------------------------------------------------------------

func is_first_time_talking_with_monk_4() -> bool:
	return _first_time_talking_with_monk_4.value

func talked_with_monk_4_for_the_first_time() -> void:
	_first_time_talking_with_monk_4.value = true
	talked_with_monk_4_for_the_first_time_signal.emit()

