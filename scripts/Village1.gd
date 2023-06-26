extends Node2D

@onready var yellow_town_guard: CharacterBody2D = $"NPCs/Yellow (Town Guard)"
@onready var dialogue_area: DialogueAction = $"NPCs/Yellow (Town Guard)/DialogueArea"

func _ready() -> void:
	Village1Autoload.permission_granted_to_leave_town.connect(_on_permission_to_leave_town)
	
	if Village1Autoload.has_grant_permission_to_leave_town():
		Village1Autoload.grant_permission_to_leave_town()


func _on_permission_to_leave_town() -> void:
	print("Yello (Town Guard) repositioned.")
	yellow_town_guard.global_position = Vector2(1624, 2736)
	dialogue_area.start_automatic = false
	var bounds : CollisionShape2D = dialogue_area.get_child(0)
	bounds.shape = CircleShape2D.new()
	bounds.shape.radius = 16.0
