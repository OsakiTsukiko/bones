extends CharacterBody3D

# @onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite3D

const SPEED = 100  # Adjust the speed as needed

var player: Node3D

func init(p_player: Node3D) -> void:
	player = p_player

func _physics_process(delta):
	if position.x > player.position.x - .2 and position.x < player.position.x + .2 and position.y > player.position.y - .2 and position.y < player.position.y + .2:
		return
	look_at(player.position);
	
	var direction = Vector3.FORWARD;
	if (direction != Vector3.ZERO):
		# anim_player.current_animation = "run"
		anim_sprite.animation = "run"
	
	direction = direction.normalized()
	velocity = transform.basis * direction * delta * SPEED;
	
	move_and_slide();

func flip(val: bool):
	anim_sprite.flip_h = val
