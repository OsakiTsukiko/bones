extends CharacterBody3D

@onready var anim_player = $AnimationPlayer

const SPEED = 0.1  # Adjust the speed as needed

func _physics_process(delta):
	# Movement
	var direction = Vector3()
	if Input.is_action_pressed("press_w"):
		direction += Vector3.FORWARD;
	if Input.is_action_pressed("press_a"):
		direction += Vector3.LEFT;
	if Input.is_action_pressed("press_s"):
		direction += Vector3.BACK;
	if Input.is_action_pressed("press_d"):
		direction += Vector3.RIGHT;
	#if Input.is_action_pressed("press_shift"):
		#direction += Vector3.DOWN;
	#if Input.is_action_pressed("press_space"):
		#direction += Vector3.UP;
		
	if Input.is_action_pressed("press_w"):
		anim_player.current_animation = "run_back" 
	
	if Input.is_action_pressed("press_s"):
		anim_player.current_animation = "run" 
	if Input.is_action_pressed("press_d") and !Input.is_action_pressed("press_w"):
		anim_player.current_animation = "run" 
	if Input.is_action_pressed("press_a") and !Input.is_action_pressed("press_w"):
		anim_player.current_animation = "run" 
	
	if direction == Vector3.ZERO:
		anim_player.current_animation = "idle" 
	
	# Normalize direction to ensure consistent speed regardless of direction
	direction = direction.normalized()
	velocity = direction * SPEED;
	
	move_and_slide();
	
	print(position)
