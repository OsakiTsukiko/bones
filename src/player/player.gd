extends CharacterBody3D

# @onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite3D

@onready var shield = $Shield
@onready var sword = $Sword

@onready var attack_timer = $AttackTimer

var sword_texture = load("res://assets/misc/sword.png")
var shield_texture = load("res://assets/misc/shield.png")
var heart_filled = load("res://assets/ui/heart_filled.png")
var heart_empty = load("res://assets/ui/heart_empty.png")

var SPEED = 120  # Adjust the speed as needed

var target_rotation;
var rotation_speed = 10
var lifes = 3

enum iih {
	SWORD,
	SHIELD
}

var item_in_hand = iih.SWORD

func take_damage(value: int):
	# print("DAMAGE: ", value)
	if (item_in_hand == iih.SHIELD && Input.is_action_pressed("attack")):
		return
	print(lifes)
	lifes -= 1
	if (lifes == 0):
		# GAME OVER 
		pass 
	if (lifes == 1):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled
	
	if (lifes == 2):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled
	
	if (lifes == 3):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled

func _ready() -> void:
	target_rotation = rotation.y

func _physics_process(delta):
	if Input.is_action_just_pressed("swap") && !Input.is_action_pressed("attack"):
		if (item_in_hand == iih.SWORD):
			item_in_hand = iih.SHIELD
			$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HAND/MarginContainer/TextureRect.texture = shield_texture
		
		else:
			item_in_hand = iih.SWORD
			$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HAND/MarginContainer/TextureRect.texture = sword_texture
		
	if Input.is_action_pressed("attack") && item_in_hand == iih.SHIELD:
		shield.visible = true
		SPEED = 50
	if Input.is_action_just_released("attack") && item_in_hand == iih.SHIELD:
		shield.visible = false 
		SPEED = 120
		
	if Input.is_action_pressed("attack") && item_in_hand == iih.SWORD:
		if (attack_timer.is_stopped()):
			shield.visible = false 
			SPEED = 120
			print("ATTACK")
			attack_timer.start()
		
	
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


func _on_attack_body_entered(body: Node3D) -> void:
	if (body.has_method("attack")):
		body.attack()


func _on_attack_body_exited(body: Node3D) -> void:
	if (body.has_method("stop_attack")):
		body.stop_attack()
