extends GridContainer

@onready var bus_label: Label = $Bus_Label
@onready var bus_volume: HSlider = $Bus_Volume
@onready var bus_mute: Button = $Bus_Mute
@onready var templates: Array = [bus_label, bus_volume, bus_mute]


func _ready() -> void:
	for bus in Audio.user_buses:
		var BusLabel: Label = bus_label.duplicate()
		BusLabel.name = BusLabel.name.replace("Bus", bus)
		BusLabel.text = "$_%s" % bus.to_upper()
		add_child(BusLabel)
		
		var BusVolume: HSlider = bus_volume.duplicate()
		BusVolume.name = BusVolume.name.replace("Bus", bus)
		BusVolume.value = Audio.get_volume(bus)
		BusVolume.value_changed.connect(Audio.set_volume.bind(bus))
		Audio.connect(bus.to_lower() + Audio.VOLUME_CHANGED, BusVolume.set_value)
		add_child(BusVolume)
		
		var BusMute: Button = bus_mute.duplicate()
		BusMute.name = BusMute.name.replace("Bus", bus)
		BusMute.button_pressed = Audio.is_mute(bus)
		BusMute.toggled.connect(Audio.set_mute.bind(bus))
		Audio.connect(bus.to_lower() + Audio.MUTE_CHANGED, BusMute.set_pressed)
		add_child(BusMute)
		
	for node in templates:
		node.hide()
		node.queue_free()
		


