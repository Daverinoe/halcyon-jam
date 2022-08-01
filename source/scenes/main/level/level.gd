extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_child(tween)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "colonel":
		if AudioServer.get_bus_effect(4, 0).cutoff_hz < 5000:
			AudioServer.get_bus_effect(4, 0).cutoff_hz = 20000
		else:
			AudioServer.get_bus_effect(4, 0).cutoff_hz = 500
	$audio/music.stop()


func _on_Area2D2_body_entered(body: Node) -> void:
	if body.name == "colonel":
		$audio/night_ambience.stop()
		$audio/music.stream = load("res://assets/audio/music/25 Norwegian Folk Songs and Dances, Op. 17 - 22. Cow Call - So Lokka Me Over Den Myra (For Recorder Ensemble - Papalin).mp3")
		$audio/music.volume_db = -20
		$audio/music.play()
		yield(get_tree().create_timer(1.0), "timeout")
		$audio/cock_crow.play()
		Global.can_control = false
		
		tween.interpolate_property(
			$CanvasLayer/TextureRect,
			"modulate",
			Color(1.0, 1.0, 1.0, 0.0),
			Color(1.0, 1.0, 1.0, 1.0),
			5,
			0,
			2,
			38
		)
		
		tween.interpolate_property(
			$CanvasLayer/Label,
			"modulate",
			Color(1.0, 1.0, 1.0, 0.0),
			Color(1.0, 1.0, 1.0, 1.0),
			5,
			0,
			2,
			2
		)
		
		tween.interpolate_property(
			$CanvasLayer/Label2,
			"modulate",
			Color(1.0, 1.0, 1.0, 0.0),
			Color(1.0, 1.0, 1.0, 1.0),
			5,
			0,
			2,
			6
		)
		
		tween.interpolate_property(
			$CanvasLayer/Label,
			"modulate",
			Color(1.0, 1.0, 1.0, 1.0),
			Color(1.0, 1.0, 1.0, 0.0),
			5,
			0,
			2,
			11
		)
		
		tween.interpolate_property(
			$CanvasLayer/Label2,
			"modulate",
			Color(1.0, 1.0, 1.0, 1.0),
			Color(1.0, 1.0, 1.0, 0.0),
			5,
			0,
			2,
			16
		)
		
		tween.start()
		yield($audio/music, "finished")
		SceneManager.load_scene("main_menu")
