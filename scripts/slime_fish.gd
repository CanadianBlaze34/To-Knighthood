class_name SlimeFish extends Entity

@onready var defense_box: DefenseBox = $DefenseBox
@onready var item_dropper: ItemDropper = $ItemDropper


func _ready() -> void:
	defense_box.dead.connect(_on_dead)


func _on_dead() -> void:
	item_dropper.drop_item(global_position)
