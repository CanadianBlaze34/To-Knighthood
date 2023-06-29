class_name MysteryForest extends Node2D


@onready var slime_fish_event: SlimeFishEvent = $Events/SlimeFishEvent
var slimes: SpawnForestSlimes

@onready var monsters: Node2D = $Monsters


func _ready() -> void:
	print("MysteryForest::_ready")
	_spawn_slime_forest_spawner()
	_connect_signals()


func _spawn_slime_forest_spawner() -> void:
	print("MysteryForest::_spawn_slime_forest_spawner")
	slimes = SpawnForestSlimes.new()
	slimes.name = "ForestSlimeSpawner"
	print("MysteryForest::_spawn_slime_forest_spawner: ", slimes.name)
	print("MysteryForest::_spawn_slime_forest_spawner: ", monsters.name)
	monsters.call_deferred("add_child", slimes)


func _connect_signals() -> void:
	print("MysteryForest::_connect_signals")
	slime_fish_event.spawn_monster.connect(_on_spawn_monster)
	slimes.spawn_monster.connect(_on_spawn_monster)


func _on_spawn_monster(entity : Entity) -> void:
	print("MysteryForest::_on_spawn_monster")
	monsters.call_deferred("add_child", entity)
