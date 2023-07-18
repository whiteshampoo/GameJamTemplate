extends ColorRect

@export var skip_on_os_locale: bool = true
@export var lang_button: PackedScene

@onready var Buttons: HBoxContainer = $Buttons

func _ready() -> void:
	var locales: Array = Game.locales.keys()
	match locales.size():
		0:
			Config.settings["misc"]["locale"] = ""
		1:
			Config.settings["misc"]["locale"] = locales[0]
	if locales.size() <= 1:
		Game.next_scene()
		return
			
	if Config.settings["misc"]["locale"] in locales:
		TranslationServer.set_locale(Config.settings["misc"]["locale"])
		Game.next_scene()
		return
	
	if skip_on_os_locale:
		var os_locale: String = OS.get_locale_language()
		if os_locale in locales:
			TranslationServer.set_locale(os_locale)
			Game.next_scene()
			return
			
	for locale in locales:
		var LangButton: Button = lang_button.instantiate()
		LangButton.name = locale
		LangButton.text = Game.locales[locale]
		LangButton.pressed.connect(Game.change_locale.bind(locale))
		LangButton.pressed.connect(Game.next_scene)
		Buttons.add_child(LangButton)

