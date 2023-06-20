class_name Village_1 extends Node # AutoLoad

#var found_Ashleys_cat : String = "" # ["has" | "gave"]
var ashleys_cat : SaveString # ["has" | "gave"] (String)
var quests_completed : SaveInt # 0, 1, 2, 3 (int)
var undead_killed : SaveInt # 0, 1, 2, 3, 4, 5 SaveBitField
var roes_milk : SaveString # ["has" | "gave"]
var permission_to_leave : bool = false
var finished_jills_quest : SaveBool

const parents_sword_name : String = "Knights Quest"
const undead_quantity : int = 5

signal permission_granted_to_leave_town
signal found_cat
signal has_item(item_name : String)
signal gave_item(item_name : String)
signal gave_parents_sword



func _ready() -> void:
	SaveLoad.save_changed.connect(_set_save_variables)
	has_item.connect(_check_item)

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


func _free_save_variables() -> void:
	ashleys_cat.delete()
	quests_completed.delete()
	undead_killed.delete()
	roes_milk.delete()
	finished_jills_quest.delete()


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
	gave_item.emit("Roes Milk")

func found_roes_milk() -> void:
	roes_milk.value = "has"

func is_roes_milk_found() -> bool:
	return roes_milk.value == "has"

func gave_roes_milk() -> bool:
	return roes_milk.value == "gave"

func spawn_roes_milk() -> bool:
	return roes_milk.value == ""

# Undead ---------------------------------------------------------

func killed_all_undead() -> bool:
#	const undead_quantity : int = 5
#	return undead_killed.value >= undead_quantity
	var undead_max : int = (Village_1._bitdex(0) + Village_1._bitdex(1) +
		Village_1._bitdex(2) + Village_1._bitdex(3) + Village_1._bitdex(4))
	
	return undead_killed.value == undead_max

func all_undead_are_killed() -> void:
	_quest_complete()

func killed_undead(undead_index : int) -> void:
	undead_killed.value |= Village_1._bitdex(undead_index)


# Jill -------------------------------------------------------------

func has_talked_to_Jill_to_finish_quest() -> bool:
	return finished_jills_quest.value

func jills_quest_finished() -> void:
	finished_jills_quest.value = true
	all_undead_are_killed()

# ----------------------------------------------------------------

func _check_item(item_name : String) -> void:
	match item_name:
		"Roes Milk":
			found_roes_milk()


func permission_to_leave_town() -> void:
	permission_to_leave = true
	permission_granted_to_leave_town.emit()


func give_parents_sword() -> void:
	print("Received %s." % [parents_sword_name])
	gave_parents_sword.emit()


static func _bitdex(index : int) -> int: 
	# converts index to bit index
	return 1 << index
