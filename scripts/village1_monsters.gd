class_name Village1Monsters extends Node2D

@onready var skeleton_1: Skeleton = $Skeleton1
@onready var skeleton_2: Skeleton = $Skeleton2
@onready var skeleton_3: Skeleton = $Skeleton3
@onready var skeleton_4: Skeleton = $Skeleton4
@onready var skeleton_5: Skeleton = $Skeleton5
# will not remove skeleton nodes when queue_free()
# not removed to easily access with a bitfield
@onready var undead : Array[Skeleton] = [
	skeleton_1, skeleton_2, skeleton_3, skeleton_4, skeleton_5
]


func _ready() -> void:
	# this scene is added after the file has been loaded
	_remove_loaded_undead()
	EntityAutoload.death.connect(_on_entity_death)


func _remove_loaded_undead() -> void:
	
	print("'undead_killed' value: %d." % [Village1Autoload.undead_killed.value])
	
	if Village1Autoload.killed_all_undead():
		for i in Village1Autoload.undead_quantity:
			undead[i].queue_free()
		undead.clear()
		print("removed all undead.")
		
	else:
		
		for i in Village1Autoload.undead_quantity:
			# the bit has been set, unspawn the undead
			if Village1Autoload.undead_killed.value & Village1Autoload_._bitdex(i):
				print("skeleton%d removed with bit %d." % [i + 1, Village1Autoload_._bitdex(i)])
				undead[i].queue_free()


func _on_entity_death(node: Entity) -> void:
	if node is Skeleton:
		
		var undead_to_remove := node as Skeleton
		
		# already removed
		if not undead_to_remove in undead:
			return
		
		for i in Village1Autoload.undead_quantity:
			if undead[i] == undead_to_remove:
				undead[i].queue_free()
				Village1Autoload.killed_undead(i)
				print("'undead_killed' value: %d." % [Village1Autoload.undead_killed.value])
				print("skeleton%d removed with bit %d." % [i + 1, Village1Autoload_._bitdex(i)])
				break
		
		print("%s died in village1." % [node.name])
		
		if Village1Autoload.killed_all_undead():
			undead.clear()

