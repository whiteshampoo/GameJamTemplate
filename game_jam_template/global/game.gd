extends Node

signal locale_changed(locale: String)

@export_category("Startup Settings")
@export var start_up_scenes: Array[PackedScene]
@export var skip_to_scene: int = 0
@export var skip_startup: bool = false
@export_file("*.tscn") var fallback_scene: String = "res://game_jam_template/menu/menu.tscn"

@onready var locales: Dictionary = load_locales()

var current_scene: int = 0
var last_scene: String = ""

func _ready() -> void:
	assert(FileAccess.file_exists(fallback_scene), "No fallback_scene selected!")
	if not get_tree().current_scene is _BLANK_:
		return
	if is_debug():
		if skip_to_scene < 0:
			current_scene = start_up_scenes.size() - 1
		else:
			current_scene = min(skip_to_scene, start_up_scenes.size() - 1)
		if skip_startup:
			current_scene = start_up_scenes.size() - 1
	next_scene()


func load_locales() -> Dictionary:
	var output: Dictionary = Dictionary()
	for locale in TranslationServer.get_loaded_locales():
		output[locale] = TranslationServer.get_translation_object(locale).get_message("$_LANGUAGE")
	return output


func is_debug() -> bool:
	return not OS.has_feature("release")


func is_release() -> bool:
	return OS.has_feature("release")


func change_scene_to_file(path: String) -> Error:
	last_scene = get_tree().current_scene.scene_file_path
	return get_tree().change_scene_to_file(path)


func change_scene_to_packed(packed_scene: PackedScene) -> Error:
	last_scene = get_tree().current_scene.scene_file_path
	return get_tree().change_scene_to_packed(packed_scene)


func next_scene() -> void:
	change_scene_to_packed(start_up_scenes[current_scene])
	current_scene = min(current_scene + 1, start_up_scenes.size() - 1)


func change_locale(locale: String) -> void:
	Config.settings["misc"]["locale"] = locale
	TranslationServer.set_locale(locale)
	locale_changed.emit(locale)


func quit() -> void:
	get_tree().quit()
