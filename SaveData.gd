extends Node

const DATA_PATH := "user://data.save"
var save_data: Dictionary

func _ready() -> void:
	_saveDictionary()

func SetKey(key: String, keyvalue):
	save_data[key] = keyvalue
	_loadDictionary()

func DeleteKey(key: String):
	save_data.erase(key)
	_loadDictionary()

func HasKey(key: String):
	return save_data.has(key)

func GetKey(key: String):
	return save_data[key]

func ClearAll():
	save_data.clear()
	_saveDictionary()

func _saveDictionary():	
	var file = FileAccess
	if file.file_exists(DATA_PATH):
		var file_read = file.open(DATA_PATH,FileAccess.READ)
		save_data = file_read.get_var()
		file_read.close()


func _loadDictionary():
	var file =  FileAccess.open(DATA_PATH,FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
