extends Node2D


export(NodePath) var colonel_path
var colonel


var __resolution : Vector2 = Vector2(1024, 768)

var __left_bound : float
var __right_bound : float
var __top_bound : float
var __bottom_bound : float

var __chicken_pos : Vector2

func _ready() -> void:
	 colonel = get_node(colonel_path)

func _physics_process(delta: float) -> void:
	__chicken_pos = colonel.get_global_transform().get_origin()
	var pos = self.get_global_transform().get_origin()
	
	__left_bound = pos.x - __resolution.x/2
	__right_bound  = pos.x + __resolution.x/2
	__top_bound  = pos.y - __resolution.y/2
	__bottom_bound  = pos.y + __resolution.y/2

	if __chicken_pos.x < __left_bound:
		self.position.x -= __resolution.x
	if __chicken_pos.x > __right_bound:
		self.position.x += __resolution.x
	if __chicken_pos.y < __top_bound:
		self.position.y -= __resolution.y
	if __chicken_pos.y > __bottom_bound:
		self.position.y += __resolution.y
