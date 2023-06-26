class_name PickupableItem extends Sprite2D

@export var item : ItemData
@export var quantity : int = 1

func _ready() -> void:
	_ready_variabless()
#	return
	print("PickupableItem::_ready: item '%s'" % [name])
	PickupableItemTrackerAutoload.editor_PickupableItem_spawned.emit(self)


func pickedup() -> void:
#	return
	print("PickupableItem: removed item '%s'" % [name])
	PickupableItemTrackerAutoload.editor_PickupableItem_removed.emit(self)


func _ready_variabless() -> void:
	texture = item.texture
	name = item.name
	print("PickupableItem::_ready_variabless: item '%s'" % [name])

