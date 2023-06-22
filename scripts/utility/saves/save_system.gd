class_name SaveSystem extends Node

@onready var _data : Dictionary = {} # Dictionary[String, String]
# Format: Dictionary[class_name_class_property_name, class_property_value]
#     ex: data[character_position_x] = var_to_str(character.position.x)
#         data[character_speed] = var_to_str(character.speed)

var _save_file_name : String = "save1"

# true when the save file could not be created
var _disable_saving : bool = false


const save_file_extension : String = ".save"

var variables : Array[SaveVariable]

signal save_changed
signal variables_loaded_from_file

func _ready() -> void:
	
#	var successful_load : bool = _try_load_data_from_save_file()
#
#	if not successful_load:
#		# no file to load from
#		# create save file
#		# disable saving if the save file could not be created
#		_disable_saving = not SaveSystem._create_save_file(_save_file_name)
	pass

#func append_variable(new_variable : SaveVariable) -> void:
#
#	# overwrites the previous SaveVariable object with the 'new_variable' SaveVariable object
#
#	for variable in variables:
#		if variable.name == new_variable.name:
#			return
#
#	print("Append '%s' SaveVariable." % [new_variable.name])
#	variables.append(new_variable)


# loading


func load_variables() -> void:
	if variables.is_empty():
		return
	
	print("Loading from save '%s'." % [_save_file_name])
	
	var not_in_file : bool = false
	
	for variable in variables:
		print(variable.name)
#		if variable.name in _data:
#			variable.value = _data[variable.name]
		if variable.load_variable(_data):
			not_in_file = true
#			print("loading '%s' to '%s'." % [variable.name, variable.value])
	if not_in_file:
		# save all variables to the file
		quick_save()
	
	variables_loaded_from_file.emit()


func _try_load_data_from_save_file() -> bool:
	# returns true on a succesful file load
	
	# check if there is a save file already exists
	# return false if there are no created save files
	var save_file : FileAccess = SaveSystem._save_file(_save_file_name, FileAccess.READ)
	if not save_file:
		return false
	
	
	# extract the data in the save file into 'data'
	self._data = SaveSystem._get_data_from(save_file)
	
	return true


func get_loaded(data_keys : Array) -> Dictionary:
	
	# copy and return the relevant data from self._data
	
	var data : Dictionary = {}
	
	for key in data_keys:
		if key in self._data:
			data[key] = self._data[key]
	
	return data


static func save_dir_exists() -> bool:
	var save_dir_path : String = SaveSystem._get_save_dir_path()
	return DirAccess.dir_exists_absolute(save_dir_path)


static func get_all_saves() -> PackedStringArray:
	var saves := PackedStringArray()
	if SaveSystem.save_dir_exists():
		var save_dir_path : String = SaveSystem._get_save_dir_path()
		var file_names : PackedStringArray = DirAccess.get_files_at(save_dir_path)
		var filtered_file_names : PackedStringArray = SaveSystem._filter_files(file_names, save_file_extension, true)
		saves = filtered_file_names
	return saves


static func get_save_count() -> int:
	return SaveSystem.get_all_saves().size()


static func _filter_files(file_names: PackedStringArray, extension : String, remove_extension : bool) -> PackedStringArray:
	
	var filtered_file_names := PackedStringArray()
	
	for file_name in file_names:
		if file_name.ends_with(extension):
			if remove_extension:
				filtered_file_names.append(file_name.substr(0, file_name.length() - extension.length()))
			else:
				filtered_file_names.append(file_name)
	
	return filtered_file_names


# saving

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("save") and not _disable_saving and not variables.is_empty():
		print("Saving '%s'." % [_save_file_name])
#		var data : Dictionary = {}
		for variable in variables:
			variable.save_variable(_data)
#			data[variable.name] = variable.value
#			print("saving '%s' as '%s'." % [variable.name, variable.value])
		quick_save()


func quick_save() -> bool:
	return save(_data, false)


func save(data : Dictionary, merge : bool = true) -> bool:
	# returns true on a succesful save to file
	
#	if _disable_saving:
#		return false
	
	# check for the save file
	# return false on any errors
	var save_file : FileAccess = SaveSystem._save_file(_save_file_name, FileAccess.WRITE)
	if not save_file:
		return false
	
	
	# append/overwrite data to self._data
	if merge:
		self._data.merge(data, true)
#	else:
#		for key in data.keys():
#			self._data[key] = data[key]
	
	
	# save self.data to the file
	# JSON provides a static method to serialized JSON string.
	var json_string : String = JSON.stringify(self._data)
	
	# overwrite the save file as a single line.
	save_file.store_line(json_string)
	
	print("Saved save file '%s'." % [_save_file_name])
	return true


func change_save(save_name : String) -> void:
	_save_file_name = save_name
	save_changed.emit()


func new_save_auto() -> void:
	const _default_save_file_name : String = "save"
	var save_number : int = SaveSystem.get_save_count() + 1
	var save_name : String = "%s%d" % [_default_save_file_name, save_number]
	
	new_save(save_name)


func set_save(save_name : String)  -> void:
	change_save(save_name)
	_try_load_data_from_save_file()


func new_save(name_ : String) -> void:
	change_save(name_)
	SaveSystem._create_save_file(_save_file_name)
	_try_load_data_from_save_file()


func delete_save(save_name : String) -> void:
	SaveSystem._delete_save_file(save_name)


# static file access

static func _get_save_dir_path() -> String:
	
	const user_prefix : String = "user://"
	const save_dir_path : String = "save/"
	
	const absolute_save_dir_path : String = user_prefix + save_dir_path
	
	return absolute_save_dir_path


static func _get_save_path(save_file_name : String) -> String:
	
#	save_file_name : String = "save"
	
	# check if the directory already exists
	# create the directory if it doesn't exist
	var save_dir_path : String = SaveSystem._get_save_dir_path()
	if not SaveSystem.save_dir_exists():
		DirAccess.make_dir_absolute(save_dir_path)
		push_warning("Created the folder/directory '%s'." % [save_dir_path])
	
	var save_path : String = save_dir_path + save_file_name + save_file_extension
	
	return save_path


static func _save_file(save_file_name : String, modeFlag : FileAccess.ModeFlags) -> FileAccess:
	# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
	
	var save_path : String = SaveSystem._get_save_path(save_file_name)
	var save_file : FileAccess = FileAccess.open(save_path, modeFlag)
	
	if not save_file:
		var error : Error = FileAccess.get_open_error()
		push_error("Error opening save_path '%s'. %s" % [save_path, error_string(error)])
	
	return save_file


# static loading

static func _get_data_from(save_file : FileAccess) -> Dictionary:
	
	# the save_file is only one line
	var json_string : String = save_file.get_line()
	
	var data : Dictionary = {}
	
	# return when there is nothing to parse
	if json_string.is_empty():
		push_warning("save file is empty")
		return data
	
	# Creates the helper class to interact with JSON
	var json := JSON.new()
	
	# Check if there is any error while parsing the JSON string, skip in case of failure
	var error : Error = json.parse(json_string)
	if error != OK:
		push_warning("JSON Parse Error: '%s'/'%s' in '%s' at line '%d'." % [json.get_error_message(), error_string(error), json_string, json.get_error_line()])
		return data
	
	# Get the data from the JSON object
	data = json.get_data()
	
	return data


# static saving

static func _create_save_file(file_name : String) -> bool:
	var save_file : FileAccess = SaveSystem._save_file(file_name, FileAccess.WRITE)
	if not save_file:
		push_error("Could not create the file '%s'." % [file_name])
		return false
	return true


# static deleting

static func _delete_save_file(file_name : String) -> void:
	var save_file : String = SaveSystem._get_save_dir_path() + file_name + save_file_extension
	
	if not FileAccess.file_exists(save_file):
		push_error("Cant delete file '%s', doesn't exist." % [file_name])
		return
	
	var error : Error = DirAccess.remove_absolute(save_file)
	if error:
		push_error(error_string(error))











