extends KinematicBody2D


var __direction : Vector2 = Vector2.ZERO
var __velocity : Vector2 = Vector2.ZERO
var __speed : float = 60.0
var __gravity : float = 10.0

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("move_left"):
		__direction.x -= 1
	if Input.is_action_pressed("move_right"):
		__direction.x += 1
	
	__direction.x *= __speed * delta
#	__direction.y += __gravity
	__velocity = move_and_slide(__direction)

func __reflect() -> void:
	__direction.x *= -1
