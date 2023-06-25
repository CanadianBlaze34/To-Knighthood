class_name PreloadItemsAutoload_ extends Node # Autoload

@onready var _roes_milk : ItemData = preload("res://resources/items/roes_milk.tres")
@onready var _sword: ItemData = preload("res://resources/items/Sword.tres")

static var _items : Dictionary # Dictionary[id : int, item : ItemData]


func _ready() -> void:
	_items = {
		_roes_milk.id : _roes_milk,
		_sword.id : _sword,
	}


static func get_item(id_ : int) -> ItemData:
	return _items[id_]

