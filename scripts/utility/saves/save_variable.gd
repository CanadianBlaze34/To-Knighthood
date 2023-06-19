class_name SaveVariable

var variable_name : String
var value

func init(variable_name_ : String, value_) -> void:
	variable_name = variable_name_
	value = value_
	SaveLoad.append_variable(self)
#	print("Init '%s'." % [variable_name])


func load_variable(data : Dictionary) -> bool:
#	assert("'load_variable' not implemented in child class '%s'." % name)
#	var data := SaveLoad.get_loaded([var_to_str(variable_name)])
	var not_in_file : bool = false
	
	if variable_name in data:
		value = str_to_var(data[variable_name])
		# cant convert to varient, is a String
		if not value:
			value = data[variable_name]
			print("Load: '%s' = '%s'." % [variable_name, value])
	else:
		print("Cant load: '%s'." % [variable_name])
		save_variable(data)
		not_in_file = true
	
	return not_in_file


func save_variable(data : Dictionary) -> void:
#	assert("'save_variable' not implemented in child class '%s'." % name)
	assert(value != null, "No default value for '%s' to save. Initialize 'value' with a default value" % [variable_name])
	print("Save: '%s' = '%s'." % [variable_name, value])
	data[variable_name] = value





