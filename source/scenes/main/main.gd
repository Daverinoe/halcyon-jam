extends Node2D


var settings_scene = preload("res://source/scenes/menus/settings/settings.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var settings = settings_scene.instance()
		$camera/ss_shaders.add_child(settings)
