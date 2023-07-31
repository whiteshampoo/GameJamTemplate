extends Node

const SCENES_FILE: String = "res://game_jam_template/config/scenes.txt"

signal locale_changed(locale: String)

@export_category("Startup Settings")
@export_file("*.tscn") var loading_screen: String
@export var start_up_scenes: PackedStringArray
@export var skip_to_scene: int = 0
@export var skip_startup: bool = false
@export_file("*.tscn") var fallback_scene: String = "res://game_jam_template/menu/menu.tscn"


@onready var locales: Dictionary = load_locales()

var current_scene: int = 0
var target_scene: String = ""
var last_scene: String = ""
var loaded_scenes: Dictionary = Dictionary()
var scenes: Array = Array()

func _ready() -> void:
	assert(ResourceLoader.exists(fallback_scene), "No fallback_scene selected!")
	ResourceLoader.load_threaded_request(loading_screen)
	while true:
		match ResourceLoader.load_threaded_get_status(loading_screen):
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				continue
			ResourceLoader.THREAD_LOAD_FAILED:
				quit()
				return
			ResourceLoader.THREAD_LOAD_LOADED:
				loaded_scenes[loading_screen] = ResourceLoader.load_threaded_get(loading_screen)
				break
	for scene in start_up_scenes:
		ResourceLoader.load_threaded_request(scene)
	request_scenes_from_file()
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
	if path != loading_screen and get_tree().current_scene.scene_file_path != loading_screen:
		last_scene = get_tree().current_scene.scene_file_path
		target_scene = ""
		
	if OS.has_feature("editor") and not path in scenes:
		scenes.append(path)
		
	if path in loaded_scenes:
		return change_scene_to_packed(loaded_scenes[path])
	
	match ResourceLoader.load_threaded_get_status(path):
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			#print("'%s' not loaded yet" % path)
			target_scene = path
			ResourceLoader.load_threaded_request(path)
			return change_scene_to_file(loading_screen)
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#print("'%s' currently loading" % path)
			target_scene = path
			return change_scene_to_file(loading_screen)
		ResourceLoader.THREAD_LOAD_FAILED:
			#push_error("Error while loading '%s'" % path)
			return FAILED
		ResourceLoader.THREAD_LOAD_LOADED:
			#print("'%s' already loaded" % path)
			loaded_scenes[path] = ResourceLoader.load_threaded_get(path)
			return change_scene_to_packed(loaded_scenes[path])
	return FAILED


func change_scene_to_packed(packed_scene: PackedScene) -> Error:
	if target_scene == "":
		last_scene = get_tree().current_scene.scene_file_path
	return get_tree().change_scene_to_packed(packed_scene)


func next_scene() -> void:
	change_scene_to_file(start_up_scenes[current_scene])
	current_scene = min(current_scene + 1, start_up_scenes.size() - 1)


func change_locale(locale: String) -> void:
	Config.settings["misc"]["locale"] = locale
	TranslationServer.set_locale(locale)
	locale_changed.emit(locale)


func quit() -> void:
	get_tree().quit()


func request_scenes_from_file() -> void:
	if not FileAccess.file_exists(SCENES_FILE):
		return
	var file: FileAccess = FileAccess.open(SCENES_FILE, FileAccess.READ)
	while not file.eof_reached():
		var scene: String = file.get_line()
		if not ResourceLoader.exists(scene):
			continue
		ResourceLoader.load_threaded_request(scene)
		scenes.append(scene)


func _on_tree_exiting() -> void:
	for scene in [loading_screen] + Array(start_up_scenes):
		if scene in scenes:
			scenes.erase(scene)
	
	var file: FileAccess = FileAccess.open(SCENES_FILE, FileAccess.WRITE)
	for scene in scenes.duplicate():
		if not ResourceLoader.exists(scene):
			continue
		file.store_line(scene)
	file.flush()
