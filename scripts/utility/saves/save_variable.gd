class_name SaveVariable extends Resource

var name : String
var value : set = set_value

func init(variable_name_ : String, default_value) -> void:
	name = variable_name_
	set_value(default_value)
	SaveLoad.variables.append(self)
	print("Append '%s'." % [name])
#	print("Init '%s'." % [name])


func delete() -> void:
	SaveLoad.variables.erase(self)
	print("erase '%s'." % [name])


func load_variable(data : Dictionary) -> bool:
#	assert("'load_variable' not implemented in child class '%s'." % name)
#	var data := SaveLoad.get_loaded([var_to_str(name)])
	var not_in_file : bool = false
	
	if name in data:
		
		var new_value = _convert_value(data[name])
		
		set_value(new_value)
		print("Load: '%s' = '%s'." % [name, value])
	else:
		print("Cant load: '%s'." % [name])
		save_variable(data)
		not_in_file = true
	
	return not_in_file


func save_variable(data : Dictionary) -> void:
#	assert("'save_variable' not implemented in child class '%s'." % name)
	assert(value != null, "No default value for '%s' to save. Initialize 'value' with a default value" % [name])
	print("Save: '%s' = '%s'." % [name, value])
	data[name] = str(value)


func set_value(new_value) -> void:
#	print("Set '%s' = '%s'." % [name, new_value])
	value = new_value


func _convert_value(str_value : String):
	var new_value = str_to_var(str_value)
	# cant convert to varient, is a String
	if not new_value:
		print("'%s' is a 'String'." % [name])
		new_value = str_value
	
	return new_value

