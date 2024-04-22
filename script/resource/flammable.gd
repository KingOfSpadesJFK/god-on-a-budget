extends Elemental
class_name Flammable

func _impact(_body: Node2D, burn_time) -> void:
	# Instantiate fire scene and add it to the node
	var fire_scene = preload("res://node/fire.tscn")
	var fire = fire_scene.instantiate()
	_body.add_child(fire)

	# Wait for the burn time to pass
	await _body.get_tree().create_timer(burn_time).timeout

	# Reparent the fire node to the body's parent, then remove the body
	#  This is so the fire can continue to burn after the body is gone
	var firepos = fire.get_global_position()
	fire.get_parent().remove_child(fire)
	_body.add_sibling(fire)
	fire.set_global_position(firepos)
	_body.queue_free()

	for child in fire.get_children():
		if child is CPUParticles2D:
			child.emitting = false
		if child is GPUParticles2D:
			child.emitting = false

	# Then remove the fire after a few seconds
	await fire.get_tree().create_timer(3.0).timeout
	fire.queue_free()
