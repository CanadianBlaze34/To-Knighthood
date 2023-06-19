class_name PickupableItem extends Sprite2D

@export var item : Item

func _ready() -> void:
	texture = item.texture
	name = item.name
