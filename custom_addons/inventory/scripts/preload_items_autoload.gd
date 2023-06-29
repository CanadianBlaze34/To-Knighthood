class_name PreloadItemsAutoload_ extends Node # Autoload

@onready var roes_milk : ItemData = preload("res://resources/items/roes_milk.tres")
@onready var sword: ItemData = preload("res://resources/items/Sword.tres")
@onready var knights_quest: ItemData = preload("res://resources/items/knights_quest.tres") # parents_sword
@onready var slime_goo: ItemData = preload("res://resources/items/slime_goo.tres") # parents_sword
@onready var slime_fish: ItemData = preload("res://resources/items/slime_fish.tres")

var _items : Dictionary # Dictionary[id : int, item : ItemData]



func _ready() -> void:
	_items = {
		roes_milk.id : roes_milk,
		sword.id : sword,
		knights_quest.id : knights_quest,
		slime_goo.id : slime_goo,
		slime_fish.id : slime_fish
	}


func get_item(id_ : int) -> ItemData:
	return _items[id_]

