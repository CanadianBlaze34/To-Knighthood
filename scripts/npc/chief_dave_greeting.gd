extends CharacterBody2D


func _ready() -> void:
	if Village1Autoload.has_greeted_chief_dave():
		queue_free()
	else:
		Village1Autoload.finished_greeting_chief_dave.connect(_on_finished_greeting_chief_dave)


func _on_finished_greeting_chief_dave() -> void:
	var movement := MoveTo.new()
	movement.destination = Vector2(1482, 2873)
	movement.can_move = true
	movement.name = "MoveTo"
	movement.speed = 80.0
	add_child(movement)
	movement.reached_destination.connect(_on_reached_destination)


func _on_reached_destination() -> void:
	queue_free()

