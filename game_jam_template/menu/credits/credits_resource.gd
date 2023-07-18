@tool
class_name Credits
extends Resource

@export var categories: Array#[CreditsCategory]

func _init(clean: bool = false) -> void:
	if is_instance_valid(categories) or clean:
		return
	categories.append(CreditsCategory.new())
	categories[0].name = "Example"
	var items: Array[CreditsItem] = categories[0].items
	items.append(CreditsItem.new())
	var item: CreditsItem = items[0]
	item.author = "My Self"
	item.name = "Stuff"
	item.url = ""


func get_category_index(category_name: String) -> int:
	var i: int = 0
	for category in categories:
		if category.name == category_name:
			return i
		i += 1
	return -1
		
