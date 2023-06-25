class_name PickupableItem extends Sprite2D

@export var item : ItemData
@export var quantity : int = 1

func _ready() -> void:
	_ready_variables()
	return
	PickupableItemTrackerAutoload.editor_PickupableItem_spawned.emit(self)


func _exit_tree() -> void:
	return
	PickupableItemTrackerAutoload.editor_PickupableItem_removed.emit(self)


func _ready_variables() -> void:
	print("spawn item '%s'" % [name])
	texture = item.texture
	name = item.name

