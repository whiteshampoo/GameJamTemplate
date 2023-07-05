extends Control

const SETTINGS_LABEL: String = "SettingsLabel"

@onready var Exclusive: CheckBox = $Divider/Video/Settings/Exclusive


func _ready() -> void:
	Game.locale_changed.connect(resize_labels)
	Exclusive.button_pressed = Video.exclusive_fullscreen
	resize_labels()


func resize_labels(_locale: String = "") -> void:
	var max_width: int = 0
	var labels: Array = get_tree().get_nodes_in_group(SETTINGS_LABEL)
	for label in labels:
		label.custom_minimum_size.x = 0
	for label in labels:
		label.reset_size()
	for label in labels:
		max_width = max(max_width, label.size.x)
	for label in labels:
		label.custom_minimum_size.x = max_width


func _on_exclusive_toggled(button_pressed: bool) -> void:
	Video.exclusive_fullscreen = button_pressed
