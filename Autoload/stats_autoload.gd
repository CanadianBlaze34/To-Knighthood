class_name _StatsAutoload extends Node

var total_petted : int = 0
var entities_petted : Dictionary = {} # :[entity_name : String, petted_amount : int]

signal pet(entity_name : String)

func petted(entity_name: String) -> void:
	entity_name = entity_name.to_lower()
	if entities_petted.has(entity_name):
		entities_petted[entity_name] += 1
	else:
		entities_petted[entity_name] = 1
	print("_StatsAutoload::petted: A '%s' has been petted." % [entity_name])
	pet.emit(entity_name)


func petted_amount(entity_name : String) -> int:
	entity_name = entity_name.to_lower()
	if entities_petted.has(entity_name):
		return entities_petted[entity_name]
	return 0
