class_name Village_1 extends Node

var found_Ashleys_cat : String = "" # ["has" | "gave"]
var quests_completed : int = 0 # 0, 1, 2, 3
var undead_killed : int = 0 # 0, 1, 2, 3, 4, 5
var roes_milk : String = "" # ["has" | "gave"]
var permission_to_leave : bool = false
const parents_sword_name : String = "Knights Quest"

signal permission_granted_to_leave_town
signal found_cat
signal has_item(item_name : String)
signal gave_item(item_name : String)
signal gave_parents_sword


func _ready() -> void:
	has_item.connect(_check_item)


func _check_item(item_name : String) -> void:
	match item_name:
		"Roes Milk":
			roes_milk = "has"


func permission_to_leave_town() -> void:
	permission_to_leave = true
	permission_granted_to_leave_town.emit()


func give_parents_sword() -> void:
	print("Received %s." % [parents_sword_name])
	gave_parents_sword.emit()
