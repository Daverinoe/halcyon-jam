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
var __foosteps_playing : bool = false

func _physics_process(delta: float) -> void:
	if Global.can_control:
		
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
			__play_audio("")
			__jump = lerp(__jump, __max_jump, 5 * delta)
			$sprite.scale.y = clamp(1.0 - __jump / __max_jump, 0.5, 1.0)
			$sprite.scale.x = clamp(1.0 + __jump / __max_jump, 1.0, 1.7)
			$sprite.position.y = clamp($sprite.position.y + 2, 0, 16)
			__velocity.x = 0
		
		# Handle y velocity
		__velocity.y += __gravity
		
		if (Input.is_action_just_released("jump") 
		and is_on_floor() and __jump >= __min_jump):
			__play_audio("jump")
			__velocity.y = -__jump
			__velocity.x = __last_direction * __jump_horizontal_velocity # Set x-velocity for jump
			$sprite.scale.y = 1.0
			$sprite.scale.x = 1.0
			$sprite.position.y = 0
			__jump = 0
		
		if __velocity.y >= 1000 and !is_on_floor():
			__velocity.y = 1000
		
		var v = __velocity
		__velocity = move_and_slide(__velocity, Vector2.UP, false, 4, PI/4, false)
		
		__collide_with_walls(v)
		
		if abs(__velocity.x) > 0.5 and !__foosteps_playing and is_on_floor():
			__foosteps_playing = true
			__play_audio("footsteps")
		elif abs(__velocity.x) < 0.1 and __foosteps_playing:
			__foosteps_playing = false
			__play_audio("")


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


func __play_audio(audio_name) -> void:
	var audio_player : AudioStreamPlayer = $chicken
	var audio : AudioStream
	match audio_name:
		"footsteps":
			audio = load("res://assets/audio/effects/footstep.wav")
			audio_player.stream.audio_stream = audio
			audio_player.playing = true
		"jump":
			audio = load("res://assets/audio/effects/jump.wav")
			audio_player.stream.audio_stream = audio
			audio_player.playing = true
		_:
			audio_player.stream.audio_stream = null
			audio_player.playing = false
