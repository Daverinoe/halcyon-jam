extends KinematicBody2D


var __direction : Vector2 = Vector2.ZERO
var __velocity : Vector2 = Vector2.ZERO
var __speed : float = 10.0
var __gravity : float = 50.0
var __min_jump : float = 500.0
var __max_jump : float = 2000.0
var __jump_increase_rate : float = 1000.0
var __jump_horizontal_speed : float = 20.0
var __jump : float = 0.0

var __can_jump : bool = true
var __is_grounded : bool = true

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("move_left") and __is_grounded:
		__direction.x -= 1
	if Input.is_action_pressed("move_right") and __is_grounded:
		__direction.x += 1
	
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right") and __is_grounded:
		__direction.x = 0
	
	if Input.is_action_pressed("jump") and __can_jump and __is_grounded:
		__jump += __jump_increase_rate * delta
		__jump = clamp(__jump, 0, __max_jump)
		__velocity.x = 0.0
	
	if (Input.is_action_just_released("jump") 
	and __can_jump and __is_grounded and __jump >= __min_jump):
		__velocity.y = -__jump
		__can_jump = false
		__is_grounded = false
		__jump = 0
	
	__velocity.x = __direction.x * __speed
	__velocity.y += __gravity
	__velocity = move_and_slide(__velocity, Vector2.UP, false, 4, 0)
	
	print(is_on_floor())
	
	if is_on_floor():
		__can_jump = true
		__is_grounded = true
	else:
		__can_jump = false
		__is_grounded = false

func __reflect() -> void:
	__direction.x *= -1
