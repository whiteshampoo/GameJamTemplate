class_name _BLANK_
extends ColorRect

var first_frame: bool = true

func _process(_delta: float) -> void:
	assert(first_frame)
	first_frame = false
