extends Button

signal selected

enum LANGUAGE {
	DE,
	EN,
	JP,
}

const LANGUAGES: Dictionary = {
	LANGUAGE.DE: "de",
	LANGUAGE.EN: "en",
	LANGUAGE.JP: "jp",
}

@export var lang: LANGUAGE = LANGUAGE.DE


func _on_pressed() -> void:
	Game.language = LANGUAGES[lang]
	selected.emit()
