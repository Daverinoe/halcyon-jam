extends Node2D

var resolution : Vector2 = Vector2(1024, 768)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_left_bound_body_entered(body: Node) -> void:
	self.position.x -= resolution.x


func _on_right_bound_body_entered(body: Node) -> void:
	self.position.x += resolution.x


func _on_top_bound_body_entered(body: Node) -> void:
	self.position.y -= resolution.y


func _on_bottom_bound_body_entered(body: Node) -> void:
	self.position.y += resolution.y
