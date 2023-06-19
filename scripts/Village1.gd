extends Node2D

@onready var yellow_town_guard: CharacterBody2D = $"NPCs/Yellow (Town Guard)"
@onready var dialogue_area: DialogueAction = $"NPCs/Yellow (Town Guard)/DialogueArea"

func _ready() -> void:
	Village1.permission_granted_to_leave_town.connect(_on_permission_to_leave_town)

func _on_monsters_child_exiting_tree(node: Node) -> void:
	if node is Skeleton:
		Village1.undead_killed += 1
		print("%s died in village1." % [node.name])


func _on_permission_to_leave_town() -> void:
	print("Yello (Town Guard) repositioned.")
	yellow_town_guard.global_position = Vector2(1624, 2736)
	dialogue_area.start_automatic = false
	var bounds : CollisionShape2D = dialogue_area.get_child(0)
	bounds.shape = CircleShape2D.new()
	bounds.shape.radius = 16.0
