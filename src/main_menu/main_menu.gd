extends Panel

var hub_scene: PackedScene = load("res://src/hub/hub.tscn")

func _on_button_start_pressed():
	SoundManager.play_sound("interface");
	get_tree().change_scene_to_packed(hub_scene)


func _on_button_toggle_sound_pressed():
	SoundManager.play_sound("interface");
	SoundManager.toggle_sfx();

func _on_button_exit_pressed():
	get_tree().quit()
