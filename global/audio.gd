class_name AudioBus


static func exists(bus: String) -> bool:
	return AudioServer.get_bus_index(bus) >= 0


static func get_index(bus: String) -> int:
	assert(exists(bus), "Unknown audiobus: %s" % bus)
	return AudioServer.get_bus_index(bus)


static func get_volume(bus: String) -> float:
	return clamp(db_to_linear(AudioServer.get_bus_volume_db(get_index(bus))), 0.0, 2.0)


static func set_volume(bus: String, volume: float) -> void:
	AudioServer.set_bus_volume_db(get_index(bus), linear_to_db(clamp(volume, 0.0, 2.0)))


static func is_mute(bus: String) -> float:
	return AudioServer.is_bus_mute(get_index(bus))


static func set_mute(bus: String, mute: bool) -> void:
	AudioServer.set_bus_mute(get_index(bus), mute)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
