extends OptionButton

const RENDERER_SETTING: String = "rendering/renderer/rendering_method"
const GL_RENDERER: String = "gl_compatibility"

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
		if is_gl() and mode in vulkan_modes:
			continue
		add_item(modes[mode], mode)
		id_index[mode] = id_index.size()
	select(clamp(id_index[Config.settings["video"]["vsync"]], 0, item_count))


func is_gl() -> bool:
	return ProjectSettings.get_setting(RENDERER_SETTING) == GL_RENDERER


func _on_item_selected(index: int) -> void:
	DisplayServer.window_set_vsync_mode(id_index[index])
