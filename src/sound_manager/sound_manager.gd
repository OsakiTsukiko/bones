extends Node

@onready var interfaceSound = $InterfaceSound

func play_sound(sound_name: String):
	
	match sound_name:
		"interface":
			interfaceSound.play();

func toggle_sfx():
	AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))
