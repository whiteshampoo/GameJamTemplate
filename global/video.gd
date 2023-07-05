extends Node

const VSYNC: Dictionary = {
	DisplayServer.VSYNC_DISABLED: "$_VSYNC_DISABLED",
	DisplayServer.VSYNC_ENABLED: "$_VSYNC_ENABLED",
	DisplayServer.VSYNC_ADAPTIVE: "$_VSYNC_ADAPTIVE",
	DisplayServer.VSYNC_MAILBOX: "$_VSYNC_MAILBOX",
}

@export var exclusive_fullscreen: bool = false:
	set(new_exclusive_fullscreen):
		exclusive_fullscreen = new_exclusive_fullscreen
		if Win.mode == Window.MODE_FULLSCREEN and exclusive_fullscreen:
			Win.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			return
		if Win.mode == Window.MODE_EXCLUSIVE_FULLSCREEN and not exclusive_fullscreen:
			Win.mode = Window.MODE_FULLSCREEN
			return
		

@onready var Win: Window = get_window()
var last_windowed_size: Vector2i = Vector2i.ZERO
var last_mode: Window.Mode = Window.MODE_WINDOWED
var all_screen_size: Vector2i = get_all_screen_size()


func _ready() -> void:
	Win.min_size = get_min_size()
	Win.size = Config.settings["video"]["size"]
	last_windowed_size = Win.size
	Win.position = clamp_position(Config.settings["video"]["position"])
	
	Win.size_changed.connect(_window_size_changed)
	exclusive_fullscreen = Config.settings["video"]["exclusive_fullscreen"]
	
	
	var mode: Window.Mode = Config.settings["video"]["mode"]
	if mode in [Window.MODE_FULLSCREEN, Window.MODE_EXCLUSIVE_FULLSCREEN]:
		mode = Window.MODE_EXCLUSIVE_FULLSCREEN if exclusive_fullscreen else Window.MODE_FULLSCREEN
	Win.mode = mode
	last_mode = Config.settings["video"]["last_mode"]
	
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
		"size": last_windowed_size, #DisplayServer.window_get_size(),
		"mode": DisplayServer.window_get_mode(),
		"last_mode": last_mode,
		"position": clamp_position(DisplayServer.window_get_position()),
		"exclusive_fullscreen": exclusive_fullscreen,
		"vsync": DisplayServer.window_get_vsync_mode(),
	}

func clamp_position(position: Vector2i) -> Vector2i:
	return position.clamp(
		DisplayServer.window_get_position() - DisplayServer.window_get_position_with_decorations(),
		all_screen_size)


func get_all_screen_size() -> Vector2i:
	var output: Vector2i = Vector2i.ZERO
	for screen in DisplayServer.get_screen_count():
		var screen_position: Vector2i = DisplayServer.screen_get_position(screen)
		var screen_size: Vector2i = DisplayServer.screen_get_size(screen)
		output.x = max(output.x, screen_position.x + screen_size.x)
		output.y = max(output.y, screen_position.y + screen_size.y)
	return output


func _input(event: InputEvent) -> void:
	if not event.is_action_type():
		return
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if Win.mode in [Window.MODE_WINDOWED, Window.MODE_MAXIMIZED]:
			last_mode = Win.mode
			Win.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if exclusive_fullscreen else Window.MODE_FULLSCREEN
			return
		Win.mode = last_mode


func _window_size_changed() -> void:
	if not Win.mode == Window.MODE_WINDOWED:
		return
	last_windowed_size = Win.size
