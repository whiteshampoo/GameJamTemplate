extends OptionButton

var locales: Array = Array()

func _ready() -> void:
	locales = Game.locales.keys()
	for locale in locales:
		add_item(Game.locales[locale])
	var conf_locale: String = Config.settings["misc"]["locale"]
	if conf_locale in locales:
		select(locales.find(conf_locale))


func _on_item_selected(index: int) -> void:
	Game.change_locale(locales[index])
