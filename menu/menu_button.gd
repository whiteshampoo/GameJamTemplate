extends Button

var SPECIAL: Dictionary = {
	"QUIT": Game.quit,
} # expand me

@export_file("*.tscn") var target: String = "":
	set(new_target):
		new_target = new_target.strip_edges()
		if new_target in SPECIAL:
			target = new_target
			return
		
		if FileAccess.file_exists(new_target):
			target = new_target
			return
		if new_target.begins_with("https://") and new_target.split(".", false).size() > 1:
			target = new_target
			return
		
		push_error("Invalid target '%s'" % new_target)
		assert(false, "Invalid target '%s'" % new_target)


func _ready() -> void:
	if target == "":
		push_warning("No target selected for '%s'" % name)
		return
	
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if target in SPECIAL:
		SPECIAL[target].call()
		return
	
	if FileAccess.file_exists(target):
		Game.change_scene_to_file(target)
		return
	
	OS.shell_open(target)


