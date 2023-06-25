class_name DefenseBox extends Area2D

func _on_area_entered(area: Area2D) -> void:
	print("%s has killed %s." % [area.get_parent().name, owner.name])
	EntityAutoload.death.emit(owner)
	owner.queue_free()
