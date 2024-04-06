extends Node3D

var text = load("res://assets/floor/floor_unstable.png")

func _ready() -> void:
	$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate(true)
	$MeshInstance3D.mesh.material.albedo_texture = text
