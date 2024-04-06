extends CharacterBody3D

# @onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite3D

const SPEED = 200  # Adjust the speed as needed

var player: Node3D

var is_attacking: bool
var stop_attackv: bool

func init(p_player: Node3D) -> void:
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
	$AnimAttackTimer.start()
	$AnimAttackTimer2.start()

func _on_anim_attack_timer_timeout() -> void:
	if (stop_attackv):
		is_attacking = false
	if (is_attacking):
		do_attack()
		

func _on_anim_attack_timer_2_timeout() -> void:
	for body in $ATTACK.get_overlapping_bodies():
		if (body.has_method("take_damage")):
			body.take_damage(50)
