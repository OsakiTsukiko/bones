extends CharacterBody3D
class_name Dog

signal dog_death

# @onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite3D

const SPEED = 200  # Adjust the speed as needed

var player: Node3D

var is_attacking: bool
var stop_attackv: bool

var life = 3

var id: int

func take_damage():
	SoundManager.play_sound("dog_hurt")
	life -= 1
	if (life == 0):
		dog_death.emit()

func init(p_player: Node3D) -> void:
	SoundManager.play_sound("dog_snarl")
	id = randi()
	player = p_player

func _physics_process(delta):
	#if position.x > player.position.x - .2 and position.x < player.position.x + .2 and position.y > player.position.y - .2 and position.y < player.position.y + .2:
		#return
	if (!is_attacking):
		
		look_at(player.position);
		
		var direction = Vector3.FORWARD;
		if (direction != Vector3.ZERO):
			# anim_player.current_animation = "run"
			anim_sprite.play("run")
		
		direction = direction.normalized()
		velocity = transform.basis * direction * delta * SPEED;
		
		move_and_slide();

func flip(val: bool):
	anim_sprite.flip_h = val
	if (val):
		anim_sprite.offset.x = -1080
	else:
		anim_sprite.offset.x = -540

func attack():
	is_attacking = true
	stop_attackv = false
	do_attack()

func stop_attack():
	stop_attackv = true

func do_attack():
	anim_sprite.play("attack")
	SoundManager.play_sound("dog_attack")
	$AnimAttackTimer.start()
	$AnimAttackTimer2.start()

func _on_anim_attack_timer_timeout() -> void:
	if (stop_attackv):
		is_attacking = false
	if (is_attacking):
		var tm = float(randi() % 5) / 10.0
		if (tm == 0): tm = .2
		$RndTimer.wait_time = tm
		$RndTimer.start()
		

func _on_anim_attack_timer_2_timeout() -> void:
	for body in $ATTACK.get_overlapping_bodies():
		if (body.has_method("take_damage")):
			body.take_damage(50)


func _on_rnd_timer_timeout() -> void:
	do_attack()
