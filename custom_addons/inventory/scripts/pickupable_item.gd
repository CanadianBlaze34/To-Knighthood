class_name PickupableItem extends Sprite2D

@export var item : ItemData
@export var quantity : int = 1

func _ready() -> void:
	texture = item.texture
	name = item.name
	print("spawn item '%s'" % [name])
