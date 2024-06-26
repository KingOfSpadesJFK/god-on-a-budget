extends Elemental
class_name Flammable

@export var burn_time = 5.0
@export var spread = 1.0

func _impact(_body: Node2D) -> void:
	# Instantiate fire scene and add it to the node
	var fire_scene = preload("res://node/fire.tscn")
	var fire = fire_scene.instantiate()
	fire.spread = spread
	fire.burn_time = burn_time
	_body.add_child(fire)

	await _body.get_tree().create_timer(burn_time).timeout

	_body.remove_child(fire)
	_body.get_parent().add_child(fire)
	fire.set_global_position(_body.get_global_position())
	_body.queue_free()
