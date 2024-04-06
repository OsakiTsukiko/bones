extends Node3D

var text0 = load("res://assets/floor/floor_v2.png")
var text1 = load("res://assets/floor/floor_v2_1.png")
var text2 = load("res://assets/floor/floor_v2_2.png")
var text3 = load("res://assets/floor/floor_v2_3.png")

func _ready() -> void:
	$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate(true)
	if (randi()%10 == 0):
		$MeshInstance3D.mesh.material.albedo_texture = text0
	else:
		if (randi()%8==0):
			$MeshInstance3D.mesh.material.albedo_texture = text3
		else:
			if (randi()%4==0):
				$MeshInstance3D.mesh.material.albedo_texture = text2
			else:
				$MeshInstance3D.mesh.material.albedo_texture = text1
				
			
		
