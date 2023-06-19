class_name SaveVector2 extends SaveVariable


func init(variable_name_ : String, value_ : Vector2) -> void:
	variable_name = variable_name_
	value = value_
	SaveLoad.append_variable(self)
#	print("Init Vector2 '%s'." % [variable_name])


func variable_name_x() -> String:
	return variable_name + "_x"


func variable_name_y() -> String:
	return variable_name + "_y"


func load_variable(data : Dictionary) -> bool:
#	assert("'load_variable' not implemented in child class '%s'." % name)
#	var data := SaveLoad.get_loaded([var_to_str(variable_name)])
	
	var not_in_file : bool = false
	
	if variable_name_x() in data:
		value.x = str_to_var(data[variable_name_x()])
		value.y = str_to_var(data[variable_name_y()])
		print("Load: '%s' = '%v'." % [variable_name, value])
	else:
		print("Cant load: '%s'." % [variable_name])
		save_variable(data)
		not_in_file = true
	
	return not_in_file


func save_variable(data : Dictionary) -> void:
#	assert("'save_variable' not implemented in child class '%s'." % name)
	assert(value, "No default value for '%s' to save. Initialize 'value' with a default Vector2" % [variable_name])
	print("Save: '%s' = '%v'." % [variable_name, value])
#	SaveLoad.save(get_save())
	data[variable_name_x()] = str(value.x)
	data[variable_name_y()] = str(value.y)
