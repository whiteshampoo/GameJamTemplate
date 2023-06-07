extends Node

@export_category("Startup Settings")
@export var start_up_scenes: Array[PackedScene]
@export var skip_to_scene: int = 0
@export var skip_startup: bool = false
@export_category("Window Settings")
@export var exclusive_fullscreen: bool = false

var e
var current_scene: int = 0
var language: String = "":
	set(new_language):
		assert(new_language in TranslationServer.get_loaded_locales(), "Not loaded language: %s" % new_language)
		language = new_language
		TranslationServer.set_locale(language)


func _ready() -> void:
	get_viewport().min_size.x = ProjectSettings.get_setting("display/window/size/viewport_width")
	get_viewport().min_size.y = ProjectSettings.get_setting("display/window/size/viewport_height")

	if not OS.has_feature("release"):
		if skip_to_scene < 0:
			current_scene = start_up_scenes.size() - 1
		else:
			current_scene = min(skip_to_scene, start_up_scenes.size() - 1)
	if not skip_startup:
		next_scene()


func _input(event: InputEvent) -> void:
	if not event.is_action_type():
		return
	if Input.is_action_just_pressed("toggle_fullscreen"):
		var Win: Window = get_viewport()
		if Win.mode == Window.MODE_WINDOWED:
			Win.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if exclusive_fullscreen else Window.MODE_FULLSCREEN
			return
		Win.mode = Window.MODE_WINDOWED
			


func change_scene_to_file(path: String) -> Error:
	return get_tree().change_scene_to_file(path)


func change_scene_to_packed(packed_scene: PackedScene) -> Error:
	return get_tree().change_scene_to_packed(packed_scene)


func next_scene() -> void:
	change_scene_to_packed(start_up_scenes[current_scene])
	current_scene = min(current_scene + 1, start_up_scenes.size() - 1)
