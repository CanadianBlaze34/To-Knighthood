class_name SaveVector2 extends SaveVariable


func init(variable_name_ : String, default_value : Vector2) -> void:
	super.init(variable_name_, default_value)


func variable_name_x() -> String:
	return name + "_x"


func variable_name_y() -> String:
	return name + "_y"


func load_variable(data : Dictionary) -> bool:
#	assert("'load_variable' not implemented in child class '%s'." % name)
#	var data := SaveLoad.get_loaded([var_to_str(name)])
	
	var not_in_file : bool = false
	
	if variable_name_x() in data:
		var new_value := Vector2(float(data[variable_name_x()]), float(data[variable_name_y()]))
		set_value(new_value)
		print("Load: '%s' = '%v'." % [name, value])
	else:
		print("Cant load: '%s'." % [name])
		save_variable(data)
		not_in_file = true
	
	return not_in_file


func save_variable(data : Dictionary) -> void:
#	assert("'save_variable' not implemented in child class '%s'." % name)
	assert(value, "No default value for '%s' to save. Initialize 'value' with a default Vector2" % [name])
	print("Save: '%s' = '%v'." % [name, value])
#	SaveLoad.save(get_save())
	data[variable_name_x()] = str(value.x)
	data[variable_name_y()] = str(value.y)












