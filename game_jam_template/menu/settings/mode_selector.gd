extends OptionButton

const MODE_NAME: Dictionary = {
	DisplayServer.WINDOW_MODE_WINDOWED: "$_WINDOW_WINDOWED",
	DisplayServer.WINDOW_MODE_MAXIMIZED: "$_WINDOW_MAXIMIZED",
	DisplayServer.WINDOW_MODE_FULLSCREEN: "$_WINDOW_FULLSCREEN",
}

const MODES: Array[DisplayServer.WindowMode] = [
	DisplayServer.WINDOW_MODE_WINDOWED,
	DisplayServer.WINDOW_MODE_MAXIMIZED,
	DisplayServer.WINDOW_MODE_FULLSCREEN,
]

func _ready() -> void:
	get_window().size_changed.connect(update)
	for mode in MODES:
		add_item(MODE_NAME[mode])
	update()


func update() -> void:
	var mode: DisplayServer.WindowMode = Video.get_window_mode()
	
	if mode == DisplayServer.WINDOW_MODE_MINIMIZED:
		mode = DisplayServer.WINDOW_MODE_WINDOWED
	elif mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	
	select(MODES.find(mode))


func _on_item_selected(index: int) -> void:
	Video.set_window_mode(MODES[index])
