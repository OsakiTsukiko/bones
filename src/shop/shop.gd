extends Node3D

@onready var item1 = $Object1
@onready var item2 = $Object2
@onready var item3 = $Object3
@onready var shop_keeper = $ShopKeeper


func _initialize_shop(item1_texture: Texture2D, item2_texture: Texture2D, item3_texture: Texture2D):
	item1._init_instance(item1_texture, 0.2);
	item2._init_instance(item2_texture, 0.2);
	item3._init_instance(item3_texture, 0.2);
	shop_keeper._init_instance("res://icon.svg", 0.7);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
