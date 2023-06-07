extends Node


@export_file("*.tscn") var next_scene: String = ""

func _ready() -> void:
	assert(next_scene, "No scene selected!")


func change_to_next_scene() -> Error:
	return Game.change_scene_to_file(next_scene)

