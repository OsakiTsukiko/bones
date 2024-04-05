extends Camera3D


const SPEED = 0.1  # Adjust the speed as needed

var velocity = Vector3()

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
	if Input.is_action_pressed("press_shift"):
		direction += Vector3.DOWN;
	if Input.is_action_pressed("press_space"):
		direction += Vector3.UP;
	
	# Normalize direction to ensure consistent speed regardless of direction
	direction = direction.normalized()
	
	global_translate(direction * SPEED);
	
