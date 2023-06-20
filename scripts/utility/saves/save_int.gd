class_name SaveInt extends SaveVariable

func init(variable_name_ : String, default_value : int) -> void:
	super.init(variable_name_, default_value)

func _convert_value(str_value : String):
	if str_value.is_valid_int():
		return int(str_value)
	else:
		print("'%s' is not an 'Integer'." % [name])
		return str_value
