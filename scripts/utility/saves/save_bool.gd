class_name SaveBool extends SaveVariable

func init(variable_name_ : String, default_value : bool) -> void:
	super.init(variable_name_, default_value)

func _convert_value(str_value : String):	
	if SaveBool._is_valid_bool(str_value):
		return SaveBool._bool(str_value)
	else:
		print("'%s' is not an 'Bool'." % [name])
		return str_value


static func _is_valid_bool(bool_ : String) -> bool:
	return bool_ == "true" or bool_ == "false"

static func _bool(bool_ : String) -> bool:
	return bool_ == "true"
