class_name PreloadItemsAutoload_ extends Node # Autoload

@onready var _roes_milk : ItemData = preload("res://resources/items/roes_milk.tres")
@onready var _sword: ItemData = preload("res://resources/items/Sword.tres")
@onready var _parents_sword: ItemData = preload("res://resources/items/parents_sword.tres")

var _items : Dictionary # Dictionary[id : int, item : ItemData]



func _ready() -> void:
	_items = {
		_roes_milk.id : _roes_milk,
		_sword.id : _sword,
		_parents_sword.id : _parents_sword
	}


func get_item(id_ : int) -> ItemData:
	return _items[id_]

