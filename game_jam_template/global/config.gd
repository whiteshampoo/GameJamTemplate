extends Node

@export var config_file: String = "user://settings.ini"
@export var fresh_in_editor: bool = false


@onready var settings: Dictionary = {
	"video": Video.get_settings(),
	"audio": Audio.get_settings(),
	"misc": {
		"locale": "",
	}
	# expand me
}

func _ready() -> void:
	if Game.is_debug() and fresh_in_editor:
		return
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
	settings["video"] = Video.get_settings()
	settings["audio"] = Audio.get_settings()
	settings["misc"]["locale"] = TranslationServer.get_locale()
	# expand me
	save_config()
