extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GraphicManager.connect("set_ss_shader", self, "set_shader")
	set_shader()

func set_shader() -> void:
	var mode = SettingsManager.get_setting("graphics/colorblind")
	var intensity = SettingsManager.get_setting("graphics/colorblind_intensity")
	$shaders.material.set_shader_param("mode", mode)
	$shaders.material.set_shader_param("intensity", intensity)
