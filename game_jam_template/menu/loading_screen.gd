extends Control

@onready var loading: Label = $Container/Loading
@onready var progress: ProgressBar = $Container/Progress


func _ready() -> void:
	if OS.has_feature("debug"):
		loading.text = "%s (%s)" % [tr(loading.text), Game.target_scene]


func _process(_delta: float) -> void:
	var status: Array = Array()
	match ResourceLoader.load_threaded_get_status(Game.target_scene, status):
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress.value = status[0]
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			Game.change_scene_to_file(Game.target_scene)
			return
	
	push_error("Error while loading '%s'" % Game.target_scene)
	Game.change_scene_to_file(Game.fallback_scene)
