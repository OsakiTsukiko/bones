extends Node

@onready var interface_sound = $InterfaceSound
@onready var snarl_sound = $SnarlSound
@onready var bark_sound = $BarkSound

func play_sound(sound_name: String):
	
	match sound_name:
		"interface":
			interface_sound.play();
		"bark":
			bark_sound.play()
		"snarl":
			snarl_sound.play()

func toggle_sfx():
	AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))
