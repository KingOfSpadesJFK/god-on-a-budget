extends Flammable
class_name Explosible

@export var power = 10
@export var explosion_spread = 16

func _impact(_body: Node2D) -> void:
	# Instantiate fire scene and add it to the node
	var fire_scene = preload("res://node/fire.tscn")
	var fire = fire_scene.instantiate()
	fire.spread = spread
	fire.burn_time = burn_time
	_body.add_child(fire)

	await _body.get_tree().create_timer(burn_time).timeout

	# Reparent fire to the body's parent
	_body.remove_child(fire)
	_body.get_parent().add_child(fire)
	fire.set_global_position(_body.get_global_position())
		
	# Instantiate fire scene and add it to the node
	var explode_scene = preload("res://node/explosion.tscn")
	var explosion: Explosion = explode_scene.instantiate()
	explosion.power = power
	explosion.spread = explosion_spread
	explosion.position = _body.position
	_body.add_sibling(explosion)
	_body.queue_free()

