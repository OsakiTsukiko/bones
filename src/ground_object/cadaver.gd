extends Area3D

#func player_entered(body: Node):
	#if body.has_method("is_player"):
		#body.collected_cadaver()
		#queue_free()
