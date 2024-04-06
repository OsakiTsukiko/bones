extends Panel



func _on_button_start_pressed():
	SoundManager.play_sound("interface");
	pass # Replace with function body.


func _on_button_toggle_sound_pressed():
	SoundManager.play_sound("interface");
	SoundManager.toggle_sfx();

func _on_button_exit_pressed():
	get_tree().quit()
