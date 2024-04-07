extends CharacterBody3D

# @onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite3D

@onready var shield = $Shield
@onready var sword = $Sword

@onready var attack_timer = $AttackTimer

@onready var atk_area = $LaAttack

var sword_texture = load("res://assets/misc/sword.png")
var shield_texture = load("res://assets/misc/shield.png")
var heart_filled = load("res://assets/ui/heart_filled.png")
var heart_empty = load("res://assets/ui/heart_empty.png")

var SPEED = 120  # Adjust the speed as needed
var SPED_UP_MODIFIER: float = 1
var player_money = 0
var player_fossils = 0

var target_rotation;
var rotation_speed = 10

var lives
var is_sped_up: bool = false
var is_time_up: bool = false
var extra_heart: bool = false

enum iih {
	SWORD,
	SHIELD
}

var item_in_hand 

func load_data(player_data: Dictionary):
	#print(player_data)
	#print(player_data["iih"])
	lives = player_data["lives"]
	match player_data["iih"]:
		"sword":
			item_in_hand = iih.SWORD
		"shield":
			item_in_hand = iih.SHIELD
	player_money = player_data["player_money"]
	player_fossils = player_data["player_fossils"]
	
	for item in player_data["items"]:
		match item:
			"heart":
				extra_heart = true
			"time":
				is_time_up = true
			"speed":
				is_sped_up = true
				
				SPED_UP_MODIFIER = 1.5
	
	$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer2/Boots.visible = false
	$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer2/Heart.visible = false
	$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer2/Time.visible = false
	
	if SceneManager.player_data["items"].has("speed"):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer2/Boots.visible = true
	if SceneManager.player_data["items"].has("heart"):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer2/Heart.visible = true
	if SceneManager.player_data["items"].has("time"):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer2/Time.visible = true
		
	$Camera3D/CanvasLayer/Control/VBoxContainer/VBoxContainer/HBoxContainer/RichTextLabel.text = str(player_fossils)
	$Camera3D/CanvasLayer/Control/VBoxContainer/VBoxContainer/HBoxContainer2/RichTextLabel.text = str(player_money)

func _ready() -> void:
	load_data(SceneManager.player_data)
	target_rotation = rotation.y
	
	if (lives == 1):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled
	
	if (lives == 2):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled
	
	if (lives == 3):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled
		
	if (item_in_hand == iih.SWORD):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HAND/MarginContainer/TextureRect.texture = sword_texture
	if (item_in_hand == iih.SHIELD):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HAND/MarginContainer/TextureRect.texture = shield_texture

func take_damage(value: int):
	# print("DAMAGE: ", value)
	if (item_in_hand == iih.SHIELD && Input.is_action_pressed("attack")):
		return
	# print(lives)
	if extra_heart:
		extra_heart = false
		SceneManager.player_data["items"].erase("heart")
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer2/Heart.visible = false
		return
	lives -= 1
	if (lives == 0):
		# GAME OVER 
		pass 
	if (lives == 1):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled
	
	if (lives == 2):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_empty
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled
	
	if (lives == 3):
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H1.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H2.texture = heart_filled
		$Camera3D/CanvasLayer/Control/VBoxContainer/HBoxContainer/HBoxContainer/H3.texture = heart_filled

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
		
	if Input.is_action_just_pressed("attack") && item_in_hand == iih.SWORD:
		if (attack_timer.is_stopped()):
			print("ATTACK")
			attack_timer.start()
			shield.visible = false 
			SPEED = 120
			for node in atk_area.get_overlapping_bodies():
				print(node)
				if node.has_method("take_damage"):
					node.take_damage()
		
	
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
	velocity = transform.basis * direction * delta * SPEED * SPED_UP_MODIFIER;
	
	move_and_slide();

func _exit_tree():
	SceneManager.player_data["lives"] = lives
	if item_in_hand == iih.SWORD:
		SceneManager.player_data["iih"] = "sword"
	if item_in_hand == iih.SHIELD:
		SceneManager.player_data["iih"] = "shield"
	

func is_player():
	return true

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
