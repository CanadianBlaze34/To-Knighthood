class_name MoveTo extends Node

@export var destination : Vector2
@export var speed : float = 1.0
@export var can_move : bool = false

var parent : CharacterBody2D

signal reached_destination

func _ready() -> void:
	print(get_parent().name)
	parent = get_parent() as CharacterBody2D


func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	var new_position := parent.global_position.move_toward(destination, speed * delta)
	if new_position == parent.global_position:
		reached_destination.emit()
		can_move = false
	else:
		parent.position = new_position
	
