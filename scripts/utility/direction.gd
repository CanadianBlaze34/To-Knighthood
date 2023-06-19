class_name Direction # STATIC

enum direction {
	none,
	up,
	down,
	left,
	right,
}


static func get_vector2(direction_ : direction) -> Vector2:
	match direction_:
		direction.up:
			return Vector2.UP
		direction.down:
			return Vector2.DOWN
		direction.left:
			return Vector2.LEFT
		direction.right:
			return Vector2.RIGHT
	return Vector2.ZERO


static func get_direction(normalized_vector : Vector2) -> direction:
	if normalized_vector.y < 0:
		return direction.up
	if normalized_vector.y > 0:
		return direction.down
	if normalized_vector.x < 0:
		return direction.left
	if normalized_vector.x > 0:
		return direction.right
	return direction.none
