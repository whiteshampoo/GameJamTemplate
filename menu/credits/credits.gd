# this script needs heavy refactoring
@tool
extends Control

@export_category("Import Settings")
@export var locate_credits: bool = false:
	set(__): #TODO: REFACTOR ME!
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
				var category_id: int = credits.get_category_index(category.name)
				if category_id == -1:
					credits.categories.append(category)
					continue
				var known_category: CreditsCategory = credits.categories[category_id]
				for item in category.items:
					item.updated = true
					var item_id: int = known_category.get_item_index(item.name)
					if item_id == -1:
						known_category.items.append(item)
						continue
					known_category.items[item_id] = item
		
		for category in credits.categories:
			for item in category.items.duplicate():
				if not item.updated or item.name == "":
					category.items.erase(item)
		
		for category in credits.categories.duplicate():
			if category.items.size() == 0 or category.name == "":
				credits.categories.erase(category)
					
const CENTER_START: String = "[center]"
const FORMAT: String = "[font_size=%d][color=%s]%s[/color][/font_size]\n"
const TABLE_START: String = "[table=3]\n"
const TABLE_END: String = "[/table]\n"
const CELLS: String = "[cell][right]%s[/right][/cell][cell][code]%s[/code][/cell][cell][left]%s[/left][/cell]\n"
const URL: String = "[url=%s]%s[/url]"
const CENTER_END: String = "[/center]"
@export var generate_credits: bool = false:
	set(__):
		var format_title: String = FORMAT % [title_size, title_color.to_html(), "%s"]
		var format_category: String = FORMAT % [category_size, category_color.to_html(), "%s"]
		var format_item: String = FORMAT % [item_size, item_color.to_html(), "%s"]
		var output: String = CENTER_START
		output += "\n".repeat(title_top)
		output += format_title % title
		output += "\n".repeat(title_seperation)
		for category in credits.categories:
			output += format_category % category.name
			output += "\n".repeat(category_top)
			output += TABLE_START
			for item in category.items:
				var format_left: String = format_item
				if Tools.is_url(item.url):
					format_left %= URL % [item.url, "%s"]
				format_left = format_left % item.name
				var format_right: String = format_item % item.author
				output += CELLS % [format_left, " ".repeat(item_space), format_right]
				output += (CELLS % [" ", " ".repeat(item_space), " "]).repeat(item_seperation)
			output += TABLE_END
			output += "\n".repeat(category_seperation)
				
			output += "\n"
		output += CENTER_END
		text.text = output

@export var root: String = "res://"
@export var target: String = "credits.tres"
@export var credits: Credits

@export_category("Title Style")
@export var title: String = "MyAwesomeGame"
@export_range(1, 128, 1) var title_size: int = 32
@export_range(0, 3) var title_top: int = 1
@export_range(0, 3) var title_seperation: int = 3
@export var title_color: Color = Color.WHITE

@export_category("Category Style")
@export_range(1, 128, 1) var category_size: int = 24
@export_range(0, 3) var category_top: int = 1
@export_range(0, 3) var category_seperation: int = 2
@export var category_color: Color = Color.WHITE

@export_category("Item Style")
@export_range(1, 128, 1) var item_size: int = 16
@export_range(0, 8) var item_space: int = 4
@export_range(0, 3) var item_seperation: int = 0
@export var item_color: Color = Color.WHITE


@onready var text: RichTextLabel = $Text



func _ready() -> void:
	locate_credits = true

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
