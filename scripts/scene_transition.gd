class_name SceneTransition extends Area2D

#@export var scene_parent : Node
@export var scene : PackedScene
@export var replace : Node
@export var spawn_position := Vector2.ZERO
#@export var player : Player


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	var transition = scene.instantiate()
	var scene_parent : Node = owner.get_parent()
	print(scene_parent.name)
	scene_parent.call_deferred("add_child", transition)
	
	replace.queue_free()
	
	var player : Player = scene_parent.player
	player.global_position = spawn_position
