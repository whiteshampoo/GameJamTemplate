extends Node

@export_file("*.txt") var resource_file: String = "res://resources.txt"
@export var update_resource_file: bool = true

var resources: Dictionary = Dictionary()
var requests: Array = Array()

func _ready() -> void:
	if update_resource_file:
		tree_exiting.connect(save_resource_file)
	
	if not resource_file_is_valid() or not FileAccess.file_exists(resource_file):
		return
	
	for resource in FileAccess.get_file_as_string(resource_file).split("\n", false):
		request_resource(resource)


func _process(_delta: float) -> void:
	if requests.size() == 0:
		set_process(false)
		return
	
	for request in requests.duplicate():
		match ResourceLoader.load_threaded_get_status(request):
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				requests.erase(request)
				continue
			ResourceLoader.THREAD_LOAD_FAILED:
				requests.erase(request)
				push_error("Error while loading resource '%s'" % request)
				continue
			ResourceLoader.THREAD_LOAD_LOADED:
				requests.erase(request)
				resources[request] = ResourceLoader.load_threaded_get(request)
				continue


func resource_file_is_valid() -> bool:
	var directory: String = resource_file.get_base_dir()
	if not DirAccess.dir_exists_absolute(directory):
		push_error("resource_file is not in a valid directory ('%s')" % directory)
		return false
	var filename: String = resource_file.get_file()
	if not filename.is_valid_filename():
		push_error("resource_file is not a valid filename ('%s')" % filename)
		return false
	return true


func is_loading(path: String) -> bool:
	return ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS


func get_progress(path: String) -> float:
	var progress: Array = Array()
	ResourceLoader.load_threaded_get_status(path, progress)
	return progress[0] if progress.size() == 1 else -1.0


func has_resource(path: String) -> bool:
	if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
		resources[path] = ResourceLoader.load_threaded_get(path)
	return not resources.get(path, null) == null


func forget_resource(path: String) -> void:
	resources.erase(path)


func get_resource(path: String, reload: bool = false) -> Resource:
	if reload:
		resources.erase(path)
	
	var output: Resource = resources.get(path, null)
	if not output == null:
		return output
	
	if not ResourceLoader.exists(path):
		push_error("Resource '%s' does not exist" % path)
		return null
	
	match ResourceLoader.load_threaded_get_status(path):
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			resources[path] = ResourceLoader.load(path)
		ResourceLoader.THREAD_LOAD_IN_PROGRESS, ResourceLoader.THREAD_LOAD_LOADED:
			resources[path] = ResourceLoader.load_threaded_get(path)
			
	output = resources.get(path, null)
	if output == null:
		push_error("Cannot load resource '%s'" % path)
		resources.erase(path)
		return null
	return output


func request_resource(path: String, reload: bool = false) -> void:
	if reload:
		resources.erase(path)
	
	if not resources.get(path, null) == null:
		return
		
	if path in requests:
		return
		
	if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
			resources[path] = ResourceLoader.load_threaded_get(path)
			return
	
	if not ResourceLoader.exists(path):
		push_error("Resource '%s' does not exist" % path)
		return
	
	var error: Error = ResourceLoader.load_threaded_request(path)
	if not error == OK:
		push_error("Error while requesting resource '%s': %s" % [path, error_string(error)])
		return
	
	requests.append(path)
	set_process(true)


func save_resource_file() -> void:
	if not resource_file_is_valid():
		return
	var file: FileAccess = FileAccess.open(resource_file, FileAccess.WRITE)
	for resource in resources.keys():
		file.store_line(resource)
	file.close()
