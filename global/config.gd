extends Node

@export var config_file: String = "user://settings.ini"
@export var user_buses: PackedStringArray = ["Master"]

@onready var settings: Dictionary = {
	"video": {
		"width": ProjectSettings.get_setting("display/window/size/viewport_width"),
		"height": ProjectSettings.get_setting("display/window/size/viewport_height"),
		"mode": ProjectSettings.get_setting("display/window/size/mode"),
		"exclusive_fullscreen": false,
		"vsync": ProjectSettings.get_setting("display/window/vsync/vsync_mode"),
	},
	"audio": {
		# filled in _ready
	}
}

func _ready() -> void:
	for bus in user_buses:
		if not AudioBus.exists(bus):
			push_error("Unknown audiobus: %s" % bus)
			continue
		settings["audio"]["%s_volume" % bus] = AudioBus.get_volume(bus)
		settings["audio"]["%s_mute" % bus] = AudioBus.is_mute(bus)
	load_config()


func load_config() -> void:
	var config: ConfigFile = ConfigFile.new()
	if not FileAccess.file_exists(config_file):
		save_config()
		return
	if not config.load(config_file) == OK:
		print("Error while reading %s" % config_file.get_file())
		get_tree().quit()
		return
	for section in config.get_sections():
		if not section in settings.keys():
			continue
		for key in config.get_section_keys(section):
			if not key in settings[section].keys():
				continue
			var value: Variant = config.get_value(section, key)
			if not typeof(value) == typeof(settings[section][key]):
				if not (typeof(value) == TYPE_INT and typeof(settings[section][key]) == TYPE_FLOAT):
					print("Value %s:%s has the wrong type" % [section, key])
					push_error("Value %s:%s has the wrong type" % [section, key])
					continue
			settings[section][key] = value


func save_config() -> void:
	var config: ConfigFile = ConfigFile.new()
	for section in settings.keys():
		for key in settings[section].keys():
			config.set_value(section, key, settings[section][key])
	if not config.save(config_file) == OK:
		print("Cannot save %s" % config_file)
		push_error("Cannot save %s" % config_file)


func _on_tree_exited() -> void:
	save_config()
