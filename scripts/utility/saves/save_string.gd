class_name SaveString extends SaveVariable

func init(variable_name_ : String, default_value : String) -> void:
	super.init(variable_name_, default_value)

func _convert_value(str_value : String) -> String:
	return str_value
