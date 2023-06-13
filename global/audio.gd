extends Node

const VOLUME: String = "_volume"
const VOLUME_CHANGED: String = "_volume_changed"
const MUTE: String = "_mute"
const MUTE_CHANGED: String = "_mute_changed"

@export var user_buses: PackedStringArray = ["Master"]


func _ready() -> void:
	for idx in AudioServer.bus_count:
		var bus_name: String = AudioServer.get_bus_name(idx)
		for suffix in [VOLUME_CHANGED, MUTE_CHANGED]:
			add_user_signal(bus_name.to_lower() + suffix)
	for bus in user_buses:
		set_volume(Config.settings["audio"][bus + VOLUME], bus)
		set_mute(Config.settings["audio"][bus + MUTE], bus)


func get_settings() -> Dictionary:
	var settings: Dictionary = Dictionary()
	for bus in user_buses:
		if not exists(bus):
			push_error("Unknown audiobus: %s" % bus)
			continue
		settings[bus + VOLUME] = get_volume(bus)
		settings[bus + MUTE] = is_mute(bus)
	return settings


func exists(bus: String) -> bool:
	return AudioServer.get_bus_index(bus) >= 0


func get_bus_index(bus: String) -> int:
	assert(exists(bus), "Unknown audiobus: %s" % bus)
	return AudioServer.get_bus_index(bus)


func get_volume(bus: String) -> float:
	return clamp(db_to_linear(AudioServer.get_bus_volume_db(get_bus_index(bus))), 0.0, 2.0)


func set_volume(volume: float, bus: String) -> void:
	if is_equal_approx(volume, get_volume(bus)):
		return
	AudioServer.set_bus_volume_db(get_bus_index(bus), linear_to_db(clamp(volume, 0.0, 2.0)))
	emit_signal(bus.to_lower() + VOLUME_CHANGED, volume)


func is_mute(bus: String) -> bool:
	return AudioServer.is_bus_mute(get_bus_index(bus))


func set_mute(mute: bool, bus: String) -> void:
	if mute == is_mute(bus):
		return
	AudioServer.set_bus_mute(get_bus_index(bus), mute)
	emit_signal(bus.to_lower() + MUTE_CHANGED, mute)


