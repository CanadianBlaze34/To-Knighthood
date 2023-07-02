class_name LegendaryGoldenRaccoonFight extends Node2D


signal player_enter(player : Player)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_enter.emit(body as Player)

