@tool
class_name CreditsCategory
extends Resource

@export var name: String
@export var items: Array[CreditsItem]

func get_item_index(item_name: String) -> int:
	var i: int = 0
	for item in items:
		if item.name == item_name:
			return i
		i += 1
	return -1
