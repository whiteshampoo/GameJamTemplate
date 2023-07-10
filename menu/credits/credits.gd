@tool
extends Control


@export var locate_credits: bool = false:
	set(__):
		for file in get_credits(root):
			print(load(file).data)

@export var generate_credits: bool = false:
	set(__):
		pass

@export var root: String = "res://"
@export var target: String = "credits.json"
@export var title: String = "MyAwesomeGame"
@export var categories: Array[CreditsCategory]

func get_credits(path: String) -> PackedStringArray:
	if not DirAccess.dir_exists_absolute(path):
		push_error("Cannot access directory '%s'" % path)
		return PackedStringArray()
	var output: PackedStringArray = PackedStringArray()
	for file in DirAccess.get_files_at(path):
		if file == target:
			output.append(path.path_join(file))
	for folder in DirAccess.get_directories_at(path):
		output.append_array(get_credits(path.path_join(folder)))
	return output
