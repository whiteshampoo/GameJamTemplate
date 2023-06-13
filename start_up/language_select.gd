extends ColorRect

@export var lang_button: PackedScene

@onready var Buttons: HBoxContainer = $Buttons

func _ready() -> void:
	var loaded_locales: PackedStringArray = TranslationServer.get_loaded_locales()
	match loaded_locales.size():
		0:
			Config.settings["misc"]["locale"] = ""
		1:
			Config.settings["misc"]["locale"] = loaded_locales[0]
	if loaded_locales.size() <= 1:
		Game.next_scene()
		return
			
	if Config.settings["misc"]["locale"] in loaded_locales:
		TranslationServer.set_locale(Config.settings["misc"]["locale"])
		Game.next_scene()
		return
	
	var os_locale: String = OS.get_locale_language()
	if os_locale in loaded_locales:
		TranslationServer.set_locale(os_locale)
		Game.next_scene()
		return
			
	for locale in loaded_locales:
		var translation: Translation = TranslationServer.get_translation_object(locale)
		var LangButton: Button = lang_button.instantiate()
		LangButton.name = locale
		LangButton.text = translation.get_message("$_language")
		LangButton.pressed.connect(Game.set.bind("language", locale))
		LangButton.pressed.connect(Game.next_scene)
		Buttons.add_child(LangButton)

