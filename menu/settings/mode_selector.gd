extends OptionButton

const modes: Dictionary = {
	DisplayServer.WINDOW_MODE_WINDOWED: "$_WINDOW_WINDOWED",
	DisplayServer.WINDOW_MODE_MAXIMIZED: "$_WINDOW_MAXIMIZED",
	DisplayServer.WINDOW_MODE_FULLSCREEN: "$_WINDOW_FULLSCREEN",
}


func _ready() -> void:
	for mode in modes:
		add_item(modes[mode])
