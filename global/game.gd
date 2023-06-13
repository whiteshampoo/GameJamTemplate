extends Node

@export_category("Startup Settings")
@export var start_up_scenes: Array[PackedScene]
@export var skip_to_scene: int = 0
@export var skip_startup: bool = false


var current_scene: int = 0


func _ready() -> void:
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


func is_debug() -> bool:
	return not OS.has_feature("release")


func is_release() -> bool:
	return OS.has_feature("release")


func change_scene_to_file(path: String) -> Error:
	return get_tree().change_scene_to_file(path)


func change_scene_to_packed(packed_scene: PackedScene) -> Error:
	return get_tree().change_scene_to_packed(packed_scene)


func next_scene() -> void:
	change_scene_to_packed(start_up_scenes[current_scene])
	current_scene = min(current_scene + 1, start_up_scenes.size() - 1)
