extends OptionButton


const modes: Dictionary = {
	DisplayServer.VSYNC_DISABLED: "$_VSYNC_DISABLED",
	DisplayServer.VSYNC_ENABLED: "$_VSYNC_ENABLED",
	DisplayServer.VSYNC_ADAPTIVE: "$_VSYNC_ADAPTIVE",
	DisplayServer.VSYNC_MAILBOX: "$_VSYNC_MAILBOX",
}

const vulkan_modes: Array = [
	DisplayServer.VSYNC_ADAPTIVE,
	DisplayServer.VSYNC_MAILBOX,
]

var id_index: Dictionary = Dictionary()

func _ready() -> void:
	for mode in modes:
		if Video.is_gl() and mode in vulkan_modes:
			continue
		add_item(modes[mode], mode)
		id_index[mode] = id_index.size()
	select(clamp(Video.get_vsync(), 0, item_count))

func _on_item_selected(index: int) -> void:
	Video.set_vsync(id_index[index])
