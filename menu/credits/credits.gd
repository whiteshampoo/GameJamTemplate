@tool
extends Control


@export var locate_credits: bool = false:
	set(__):
		if not credits:
			credits = Credits.new()
			credits.categories.clear()
			
		for category in credits.categories:
			for item in category.items:
				item.updated = false
		
		for file in get_credits(root):
			print(file)
			var loaded_credits: Credits = load(file) as Credits
			if not loaded_credits:
				push_error("Invalid Credits-file '%s'" % file)
				continue
				
			for category in loaded_credits.categories:
				print(category.name)
				var category_id: int = credits.get_category_index(category.name)
				if category_id == -1:
					credits.categories.append(category)
					continue
				
				var known_category: CreditsCategory = credits.categories[category_id]
				prints("xxx", known_category.has_method("get_item_index"))
				for item in category.items:
					var item_id: int = known_category.get_item_index(item.name)
					if item_id == -1:
						known_category.items.append(item)
						continue
					known_category.items[item_id] = item
		
		for category in credits.categories:
			for item in category.items.duplicate():
				if not item.updated:
					prints("remove item", item.name)
					category.items.erase(item)
		
		for category in credits.categories.duplicate():
			if category.items.size() == 0:
				prints("remove category", category.name)
				credits.categories.erase(category)
					
				
			

@export var generate_credits: bool = false:
	set(__):
		pass

@export var root: String = "res://"
@export var target: String = "credits.tres"
@export var title: String = "MyAwesomeGame"
@export var credits: Credits

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
