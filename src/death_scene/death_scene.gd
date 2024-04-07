extends Panel


var menu_scene: PackedScene = preload("res://src/main_menu/main_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("ded")

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		_on_go_back_pressed()

func _on_go_back_pressed():
	get_tree().change_scene_to_packed(menu_scene)
