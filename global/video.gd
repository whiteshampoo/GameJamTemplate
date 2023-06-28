extends Node

const VSYNC: Dictionary = {
	DisplayServer.VSYNC_DISABLED: "$_VSYNC_DISABLED",
	DisplayServer.VSYNC_ENABLED: "$_VSYNC_ENABLED",
	DisplayServer.VSYNC_ADAPTIVE: "$_VSYNC_ADAPTIVE",
	DisplayServer.VSYNC_MAILBOX: "$_VSYNC_MAILBOX",
}

@export var exclusive_fullscreen: bool = false


func _ready() -> void:
	var Win: Window = get_window()
	Win.min_size = get_min_size()
	Win.size = Config.settings["video"]["size"]
	Win.position = Config.settings["video"]["position"]
	exclusive_fullscreen = Config.settings["video"]["exclusive_fullscreen"]
	
	
	var mode: Window.Mode = Config.settings["video"]["mode"]
	if mode in [Window.MODE_FULLSCREEN, Window.MODE_EXCLUSIVE_FULLSCREEN]:
		mode = Window.MODE_EXCLUSIVE_FULLSCREEN if exclusive_fullscreen else Window.MODE_FULLSCREEN
	Win.mode = mode
	
	var vsync: DisplayServer.VSyncMode = Config.settings["video"]["vsync"]
	if not vsync in VSYNC:
		vsync = DisplayServer.window_get_vsync_mode()
	else:
		DisplayServer.window_set_vsync_mode(vsync)


func get_min_size() -> Vector2i:
	return Vector2i(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)


func get_settings() -> Dictionary:
	return {
		"size": DisplayServer.window_get_size(),
		"mode": DisplayServer.window_get_mode(),
		"position": DisplayServer.window_get_position(),
		"exclusive_fullscreen": exclusive_fullscreen,
		"vsync": DisplayServer.window_get_vsync_mode(),
	}


func _input(event: InputEvent) -> void:
	if not event.is_action_type():
		return
	if Input.is_action_just_pressed("toggle_fullscreen"):
		var Win: Window = get_viewport()
		if Win.mode == Window.MODE_WINDOWED:
			Win.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if exclusive_fullscreen else Window.MODE_FULLSCREEN
			return
		Win.mode = Window.MODE_WINDOWED
