extends CanvasLayer

signal done_fading

func _ready():
	transition_in()

func transition_in():
	
	$AnimationPlayer.play("fade_out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_in")
	if anim_name == "fade_in":
		emit_signal("transitioned")
