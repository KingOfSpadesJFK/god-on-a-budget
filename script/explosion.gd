extends Node2D
class_name Explosion

@export var spread: float = 16.0
@export var power: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.get_shape().radius = spread
	print($Area2D/CollisionShape2D.get_shape().radius)
	$AnimationPlayer.play("new_animation")
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(0.25).timeout
	$Area2D.queue_free()
	await get_tree().create_timer(3.0).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


const FORCE_MULTIPLIER = 30

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity = (body.position - position).normalized() * power * FORCE_MULTIPLIER
		if body is Player:
			body.stats.health -= power

	if body is RigidBody2D:
		# Raycast to the body and apply impulse
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(position, body.position)
		var result = space_state.intersect_ray(query)	# Where the explosion hits the body
		body.apply_impulse((body.position-position).normalized() * power / 100, body.position - result.position)

	# Since it's fire, do the flammability thing
	if (body.has_meta("flammability")):
		var flammability = body.get_meta("flammability")
		if flammability != null and flammability is Flammable:
			flammability._impact(body)
		
