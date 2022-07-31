extends KinematicBody2D


var __direction : Vector2 = Vector2.ZERO
var __velocity : Vector2 = Vector2.ZERO
var __speed : float = 200.0
var __max_speed : float = 400.0
var __gravity : float = 50.0
var __min_jump : float = 200.0
var __max_jump : float = 1200.0
var __jump_horizontal_velocity : float = 400.0
var __jump : float = 0.0

var __friction : float = 30.0
var __acceleration : float = 20.0

var __last_direction : int = -1

onready var sprite = get_node("sprite")

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("move_left") and is_on_floor():
		__set_direction(-1)
	elif Input.is_action_pressed("move_right") and is_on_floor():
		__set_direction(1)
	else:
		__direction.x = 0
		$sprite.animation = "idle"
	
	# Handle x velocity
	if is_on_floor():
		if __direction.x != 0:
			__velocity.x = lerp(__velocity.x, __direction.x * __speed, __acceleration * delta)
		else:
			__velocity.x = lerp(__velocity.x, 0, __friction * delta)
	
	__velocity.x = clamp(__velocity.x, -__max_speed, __max_speed)


	if Input.is_action_pressed("jump") and is_on_floor():
		__jump = lerp(__jump, __max_jump, 5 * delta)
		__velocity.x = 0
	
	# Handle y velocity
	__velocity.y += __gravity
	
	if (Input.is_action_just_released("jump") 
	and is_on_floor() and __jump >= __min_jump):
		__velocity.y = -__jump
		__velocity.x = __last_direction * __jump_horizontal_velocity # Set x-velocity for jump
		__jump = 0
	
	var v = __velocity
	__velocity = move_and_slide(__velocity, Vector2.UP, false, 4, 0, false)
	
	__collide_with_walls(v)


func __collide_with_walls(before_collision_velocity) -> void:
	var v = before_collision_velocity
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider is TileMap and is_on_wall():
			__velocity.x = collision.normal.x * abs(v.x) * 0.8


func __set_direction(direction : int) -> void:
	match direction:
		-1:
			__direction.x = -1
			__last_direction = -1
			$sprite.flip_h = false
		1:
			__direction.x = 1
			__last_direction = 1
			$sprite.flip_h = true
	$sprite.animation = "walk"
