extends ColorRect

@export var lang_button: PackedScene

@onready var Buttons: HBoxContainer = $Buttons

func _ready() -> void:
	var locales: PackedStringArray = TranslationServer.get_loaded_locales()
	if not Game.language == "" or locales.size() <= 1:
		if locales.size() == 1:
			Game.language = locales[0]
		Game.next_scene()

	for locale in locales:
		var translation: Translation = TranslationServer.get_translation_object(locale)
		var LangButton: Button = lang_button.instantiate()
		LangButton.name = locale
		LangButton.text = translation.get_message("$_language")
		LangButton.pressed.connect(Game.set.bind("language", locale))
		LangButton.pressed.connect(Game.next_scene)
		Buttons.add_child(LangButton)

