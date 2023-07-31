class_name CustomMenuButton
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
		
		if ResourceLoader.exists(new_target):
			target = new_target
			return
		
		if Tools.is_url(new_target):
			target = new_target
			return
		
		if new_target == "":
			if ResourceLoader.exists(Game.last_scene):
				target = Game.last_scene
				return
			target = Game.fallback_scene
			return
			
		push_error("Invalid target '%s'" % new_target)
		assert(false, "Invalid target '%s'" % new_target)


func _ready() -> void:
	target = target
	if visible and target == "":
		push_warning("No target selected for '%s'" % name)
		return
	
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if target in SPECIAL:
		SPECIAL[target].call()
		return
	
	if ResourceLoader.exists(target):
		#Game.last_scene = self.scene_file_path
		Game.change_scene_to_file(target)
		return
	
	OS.shell_open(target)


