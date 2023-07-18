extends ColorRect

@onready var Anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Anim.play("Intro")


func _input(event: InputEvent) -> void:
	if not event.is_action_type():
		return
	if Input.is_action_just_pressed("ui_accept") or \
		Input.is_action_just_pressed("ui_cancel"):
		Game.next_scene()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	Game.next_scene()
