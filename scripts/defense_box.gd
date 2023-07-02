class_name DefenseBox extends Area2D

@export var die_on_hit : bool = true

signal dead

func _on_area_entered(area: Area2D) -> void:
	print("%s has killed %s." % [area.get_parent().name, owner.name])
	dead.emit()
	if owner is Entity:
		EntityAutoload.death.emit(owner)
	if die_on_hit:
		owner.queue_free()
