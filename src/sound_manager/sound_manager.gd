extends Node

@onready var current_music = $MusicTitle

func _ready():
	current_music.play()

func play_music(music_name: String):
	current_music.stop()
	match music_name:
		"title":
			$MusicTitle.play()
			current_music = $MusicTitle
		"dungeon":
			$MusicDungeon.play()
			current_music = $MusicDungeon

func play_sound(sound_name: String):
	
	match sound_name:
		"interface":
			$InterfaceSound.play();
		"dog_attack":
			$Dog/BarkSound.play()
		"dog_snarl":
			$Dog/SnarlSound.play()
		"dog_hurt":
			$Dog/HurtSound.play()
		"coins":
			$CoinsSound.play()
		"craft":
			$CraftSound.play()
		"player_block":
			$Player/BlockSound.play()
		"player_hurt":
			$Player/PlayerHurtSound.play()
		"player_attack":
			$Player/SwipeSound.play()
		"crystal_activate":
			$Crystal/CrystalActivateSound.play()
		"crystal_deactivate":
			$Crystal/CrystalDeactivateSound.play()

func toggle_sfx():
	AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))
