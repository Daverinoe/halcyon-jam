extends Node

func set_graphic(name: String, value) -> void:
	match name:
		"screen_resolution":
			__change_resolution(value)
		"fullscreen":
			__set_fullscreen(value)
		"colorblind":
			__set_colorblind(value)
		"colorblind_intensity":
			__set_colorblind_intensity(value)
		_:
			push_warning("Option doesn't exist.")
			pass

func __change_resolution(value: String) -> void:
	var res_vals = value.split("x")
	var resolution = Vector2(str2var(res_vals[0]), str2var(res_vals[1]))
	OS.set_window_size(resolution)


func __set_fullscreen(value: bool) -> void:
	OS.window_fullscreen = value


func __set_colorblind(value: int) -> void:
	pass


func __set_colorblind_intensity(value: float) -> void:
	pass
