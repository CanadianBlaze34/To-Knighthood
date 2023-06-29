class_name Village1Autoload_ extends Node # AutoLoad

#var found_Ashleys_cat : String = "" # ["has" | "gave"]
var ashleys_cat : SaveString # ["has" | "gave"] (String)
var quests_completed : SaveInt # 0, 1, 2, 3 (int)
var undead_killed : SaveInt # 0, 1, 2, 3, 4, 5 SaveBitField
var roes_milk : SaveString # ["has" | "gave"]
var _greeted_chief_dave : SaveBool
var permission_to_leave : SaveBool
var finished_jills_quest : SaveBool

const parents_sword_name : String = "Knights Quest"
const undead_quantity : int = 5
const roes_milk_item_id : int = 1

signal permission_granted_to_leave_town
signal found_cat
signal has_item(item_id : int)
signal dropped_item(item_id : int)
signal gave_item(item_id : int)
signal gave_parents_sword(item : ItemData, quantity : int)
signal finished_greeting_chief_dave


func _ready() -> void:
	SaveLoad.save_changed.connect(_set_save_variables)
	has_item.connect(_has_item)
	dropped_item.connect(_dropped_item)


# SaveVariable ----------------------------------------------------------------

func _set_save_variables() -> void:
	# if ANY of the SaveVariables are set, delete them all
	if ashleys_cat:
		_free_save_variables()
	# Autoload Script
	# Called once, when the program starts
	# 'found_Ashleys_cat' is used as a String and doesn't set another variable
	ashleys_cat = SaveString.new()
	ashleys_cat.init("found_Ashleys_cat", "")
	quests_completed = SaveInt.new()
	quests_completed.init("quests_completed", 0)
	roes_milk = SaveString.new()
	roes_milk.init("roes_milk", "")
	undead_killed = SaveInt.new()
	undead_killed.init("undead_killed", 0)
	finished_jills_quest = SaveBool.new()
	finished_jills_quest.init("finished_jills_quest", false)
	_greeted_chief_dave = SaveBool.new()
	_greeted_chief_dave.init("talked_to_chief_dave", false)
	permission_to_leave = SaveBool.new()
	permission_to_leave.init("permission_to_leave", false)


func _free_save_variables() -> void:
	ashleys_cat.delete()
	quests_completed.delete()
	undead_killed.delete()
	roes_milk.delete()
	finished_jills_quest.delete()
	_greeted_chief_dave.delete()
	permission_to_leave.delete()


func _exit_tree() -> void:
	# if ANY of the SaveVariables are set, delete them all
	if ashleys_cat:
		_free_save_variables()


# Quest ---------------------------------------------------------
func _quest_complete() -> void:
	quests_completed.value += 1

func completed_all_quests() -> bool:
	const quests_quantity : int = 3
	return quests_completed.value == quests_quantity

# Ashley ---------------------------------------------------------

func give_ashleys_cat() -> void:
	ashleys_cat.value = "gave"
	_quest_complete()

func found_ashleys_cat() -> void:
	ashleys_cat.value = "has"
	found_cat.emit()

func is_ashleys_cat_found() -> bool:
	return ashleys_cat.value == "has"

func gave_ashleys_cat() -> bool:
	return ashleys_cat.value == "gave"

func spawn_ashleys_cat() -> bool:
	return ashleys_cat.value == ""

# Roe ---------------------------------------------------------

func give_roes_milk() -> void:
	roes_milk.value = "gave"
	_quest_complete()
	# player removes roes_milk from inventory
#	gave_item.emit("Roes Milk")
	gave_item.emit(roes_milk_item_id)

func found_roes_milk() -> void:
	roes_milk.value = "has"

func is_roes_milk_found() -> bool:
	return roes_milk.value == "has"

func gave_roes_milk() -> bool:
	return roes_milk.value == "gave"

func dropped_roes_milk() -> void:
	roes_milk.value = ""

# Undead ---------------------------------------------------------

func killed_all_undead() -> bool:
#	const undead_quantity : int = 5
#	return undead_killed.value >= undead_quantity
	var undead_max : int = (Village1Autoload_._bitdex(0) + Village1Autoload_._bitdex(1) +
		Village1Autoload_._bitdex(2) + Village1Autoload_._bitdex(3) + Village1Autoload_._bitdex(4))
	
	return undead_killed.value == undead_max

func all_undead_are_killed() -> void:
	_quest_complete()

func killed_undead(undead_index : int) -> void:
	undead_killed.value |= Village1Autoload_._bitdex(undead_index)


# Jill -------------------------------------------------------------

func has_talked_to_Jill_to_finish_quest() -> bool:
	return finished_jills_quest.value

func jills_quest_finished() -> void:
	finished_jills_quest.value = true
	all_undead_are_killed()


# Chief Dave -------------------------------------------------------------------

func greeted_chief_dave() -> void:
	finished_greeting_chief_dave.emit()
	_greeted_chief_dave.value = true

func has_greeted_chief_dave() -> bool:
	return _greeted_chief_dave.value

func permission_to_leave_town() -> void:
	permission_to_leave.value = true
	grant_permission_to_leave_town()

func give_parents_sword() -> void:
	print("Received %s." % [parents_sword_name])
	gave_parents_sword.emit(PreloadItemsAutoload.knights_quest, 1)

# Yellow (Towns Guard) ---------------------------------------------------------

func grant_permission_to_leave_town() -> void:
	permission_granted_to_leave_town.emit()

func has_grant_permission_to_leave_town() -> bool:
	return permission_to_leave.value

# ------------------------------------------------------------------------------

func _has_item(item_id : int) -> void:
	match item_id:
#		"Roes Milk":
		roes_milk_item_id:
			found_roes_milk()

func _dropped_item(item_id : int) -> void:
	match item_id:
#		"Roes Milk":
		roes_milk_item_id:
			dropped_roes_milk()


static func _bitdex(index : int) -> int: 
	# converts index to bit index
	return 1 << index
