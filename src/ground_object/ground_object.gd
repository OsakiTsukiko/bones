extends Area3D

func _init_instance(collision_radius: float, object_texture: Texture2D = null, scl: float= .1):
	var collision_shape: CylinderShape3D = $CollisionShape3D.shape
	var sprite = $Sprite3D
	collision_shape.radius = collision_radius
	if object_texture != null:
		sprite.texture = object_texture
	sprite.scale = Vector3(scl, scl, scl)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
