extends Control


func _on_play_pressed() -> void:
	pass # Replace with function body.


func _on_load_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_godot_pressed() -> void:
	OS.shell_open("https://godotengine.org/")


func _on_itch_pressed() -> void:
	OS.shell_open("https://whiteshampoo.itch.io/")
	


func _on_game_jam_pressed() -> void:
	OS.shell_open("https://godotwildjam.com/")


func _on_quit_pressed() -> void:
	get_tree().quit()
