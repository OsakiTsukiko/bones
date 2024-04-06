extends CharacterBody3D

# @onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite3D

const SPEED = 200  # Adjust the speed as needed

var target_rotation;
var rotation_speed = 10;

func _ready() -> void:
	target_rotation = rotation.y

func _physics_process(delta):
	
	rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	
	if Input.is_action_just_pressed("rot_l"):
		target_rotation -= PI/4
	
	if Input.is_action_just_pressed("rot_r"):
		target_rotation += PI/4
	
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
		# anim_player.current_animation = "run_back" 
		anim_sprite.animation = "run_backwards"
	
	if Input.is_action_pressed("press_s"):
		# anim_player.current_animation = "run" 
		anim_sprite.animation = "run"
	if Input.is_action_pressed("press_d") and !Input.is_action_pressed("press_w"):
		anim_sprite.animation = "run"
	if Input.is_action_pressed("press_a") and !Input.is_action_pressed("press_w"):
		anim_sprite.animation = "run"
	
	if direction == Vector3.ZERO:
		anim_sprite.animation = "idle"
	
	# Normalize direction to ensure consistent speed regardless of direction
	direction = direction.normalized()
	velocity = transform.basis * direction * delta * SPEED;
	
	move_and_slide();


func _on_right_body_entered(body: Node3D) -> void:
	if (body.has_method("flip")):
		body.flip(true)


func _on_left_body_entered(body: Node3D) -> void:
	if (body.has_method("flip")):
		body.flip(false)
