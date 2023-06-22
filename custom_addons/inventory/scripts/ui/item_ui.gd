class_name ItemUI extends TextureRect

var picked : bool = false


func pick_item() -> void:
	# ignore any mouse events when holding the item
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true


func put_item() -> void:
	# listen to mouse events when no longer holding the item
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false

