extends CheckBox


func _ready() -> void:
	button_pressed = Video.exclusive_fullscreen


func _on_toggled(exclusive: bool) -> void:
	Video.exclusive_fullscreen = exclusive
