extends Node2D
class_name Fire

@export var burn_time = 5.0
@export var spread = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set up the fire particles
	for child in get_children():
		if child is CPUParticles2D:
			child.amount = spread
			child.emission_sphere_radius = spread
		if child is GPUParticles2D:
			child.amount = spread * 2
			if child.process_material is ParticleProcessMaterial:
				child.process_material.emission_sphere_radius = spread

	# Wait for the burn time to pass
	if burn_time > 0:
		await get_tree().create_timer(burn_time).timeout

		for child in get_children():
			if child is CPUParticles2D:
				child.emitting = false
			if child is GPUParticles2D:
				child.emitting = false

		# Then remove the fire after a few seconds
		await get_tree().create_timer(3.0).timeout
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
