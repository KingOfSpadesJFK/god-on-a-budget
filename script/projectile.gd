extends Node2D
class_name Projectile

@export var velocity: Vector2 = Vector2(0,0)
@export var elemental: Elemental

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func rotation_normalization() -> Vector2:
	var normal = Vector2(cos(rotation), sin(rotation))
	normal = normal.normalized()
	return normal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta * rotation_normalization()

# Called when the child Area2D touches a flammable body
func _on_flamable_body_entered(body: Node2D) -> void:
	var is_flammable = body.get_meta("flammable", false)
	var burn_time = body.get_meta("burn_time", 1.0)

	if is_flammable:
		elemental._impact(body, burn_time)
