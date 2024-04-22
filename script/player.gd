extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum PlayerState { IDLE, WALK, JUMP, FLOAT, FLY, FALL, FIRING, DEAD }
enum ElementalState { NONE, FIRE, LIGHTNING }

var direction: float
var facing_direction = 1.0
var hold_time = 0.0
var hold_elemental: ElementalState = ElementalState.NONE

func _process(_delta: float):
	direction = Input.get_axis("player_left", "player_right")
	if direction:
		facing_direction = direction

	$RichTextLabel.text = "Hold: " + str(snapped(hold_time, 0.01))
		
	# Flip the sprite.
	if facing_direction:
		$Sprite2D.flip_h = facing_direction < 0;

	if Input.is_action_just_pressed("player_fire") or Input.is_action_just_pressed("player_lightning"):
		hold_time = 0.0

	if Input.is_action_pressed("player_fire"):
		hold_elemental = ElementalState.FIRE
		hold_time += get_process_delta_time()
	elif Input.is_action_pressed("player_lightning"):
		hold_elemental = ElementalState.LIGHTNING
		hold_time += get_process_delta_time()

	if Input.is_action_just_released("player_fire"):
		create_fire()
		hold_time = 0.0
	elif Input.is_action_just_released("player_lightning"):
		hold_time = 0.0
		
		
func create_fire() -> void:
	var scene = preload("res://node/fire_projectile.tscn")
	var instance = scene.instantiate()
	instance.set_meta("elemental", 1) 
	add_sibling(instance)
	instance.position = position + Vector2(32, 0) * facing_direction
	instance.velocity = Vector2(75, 0) * Vector2(facing_direction, 1)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Projectile:
		var elemental = area.get_parent().get_meta("elemental")
		if elemental != null:
			if elemental == 1:
				print("Burn")
	
	pass
