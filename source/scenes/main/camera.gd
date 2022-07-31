extends Node2D

var __resolution : Vector2 = Vector2(1024, 768)

var __can_transition_right : bool = true
var __can_transition_left : bool = true
var __can_transition_up : bool = true
var __can_transition_down : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_left_bound_body_entered(body: Node) -> void:
	if __can_transition_left:
		self.position.x -= __resolution.x
		__can_transition_right = false


func _on_right_bound_body_entered(body: Node) -> void:
	if __can_transition_right:
		self.position.x += __resolution.x
		__can_transition_left = false


func _on_top_bound_body_entered(body: Node) -> void:
	if __can_transition_up:
		self.position.y -= __resolution.y
		__can_transition_down = false


func _on_bottom_bound_body_entered(body: Node) -> void:
	if __can_transition_down:
		self.position.y += __resolution.y
		__can_transition_up = false


func _on_left_bound_body_exited(body: Node) -> void:
	__can_transition_left = true


func _on_right_bound_body_exited(body: Node) -> void:
	__can_transition_right = true


func _on_top_bound_body_exited(body: Node) -> void:
	__can_transition_up = true


func _on_bottom_bound_body_exited(body: Node) -> void:
	__can_transition_down = true
