extends KinematicBody2D


var __direction : Vector2 = Vector2.ZERO
var __velocity : Vector2 = Vector2.ZERO
var __speed : float = 10.0
var __max_speed : float = 400.0
var __gravity : float = 50.0
var __min_jump : float = 200.0
var __max_jump : float = 1200.0
var __jump_horizontal_velocity : float = 400.0
var __jump : float = 0.0

var __friction : float = 30.0
var __acceleration : float = 20.0

var __last_direction : int = -1


func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("move_left") and is_on_floor():
		__direction.x -= 1
		__last_direction = -1
	elif Input.is_action_pressed("move_right") and is_on_floor():
		__direction.x += 1
		__last_direction = 1
	else:
		__direction.x = 0
	
	if is_on_floor():
		if __direction.x != 0:
			__velocity.x = lerp(__velocity.x, __direction.x * __speed, __acceleration * delta)
		else:
			__velocity.x = lerp(__velocity.x, 0, __friction * delta)
	
	__velocity.y += __gravity
	__velocity.x = clamp(__velocity.x, -__max_speed, __max_speed)


	if Input.is_action_pressed("jump") and is_on_floor():
		__jump = lerp(__jump, __max_jump, 5 * delta)
		__velocity.x = 0
	
	
	if (Input.is_action_just_released("jump") 
	and is_on_floor() and __jump >= __min_jump):
		__velocity.y = -__jump
		__velocity.x = __last_direction * __jump_horizontal_velocity
		__jump = 0
	
	__velocity = move_and_slide(__velocity, Vector2.UP, false, 4, 0)
	

func __reflect() -> void:
	__direction.x *= -1
