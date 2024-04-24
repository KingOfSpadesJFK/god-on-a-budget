extends CharacterBody2D
class_name Player

const MAX_SPEED = 150
const JUMP_VELOCITY = -400
const ACCELERATION = 1000
const DECELERATION = 700
const FLOAT_DECELERATION = 600

# These constants are the cost of using the elemental powers per second.
const FIRE_COST = 5
const LIGHTNING_COST = 2
const FLOAT_COST = 1

enum PlayerState { IDLE, WALK, BRAKING, JUMP, FLOAT, FLY, FALL, FIRING, DEAD }
enum ElementalState { NONE, FIRE, LIGHTNING }

var direction = 0.0
var vert_direction = 0.0
var facing_direction = 1.0
var hold_time = 0.0
var hold_elemental: ElementalState = ElementalState.NONE
var player_state: PlayerState = PlayerState.IDLE
var impulse = Vector2()

@export var stats: PlayerStats


func _input(event):
	if event.is_action_pressed("player_jump"):
		if is_on_floor():
			player_state = PlayerState.JUMP
			impulse = Vector2(0, JUMP_VELOCITY)
		elif stats.power > 0 :
			if player_state == PlayerState.FALL:
				player_state = PlayerState.FLOAT
			elif player_state == PlayerState.FLOAT:
				player_state = PlayerState.FALL


func _process(_delta: float):
	# Flip the sprite.
	if facing_direction:
		$Sprite2D.flip_h = facing_direction < 0;

	# Get player directions
	$RichTextLabel.text = "Hold: " + str(snapped(hold_time, 0.01)) + "\n" + PlayerState.keys()[player_state]
	direction = Input.get_axis("player_left", "player_right")
	vert_direction = Input.get_axis("player_up", "player_down")
	if direction:
		facing_direction = direction

	# Update player state
	if player_state != PlayerState.JUMP:
		if direction:
			if is_on_floor():
				player_state = PlayerState.WALK
		else:
			if is_on_floor():
				if  velocity.x != 0:
					player_state = PlayerState.BRAKING
				else:
					player_state = PlayerState.IDLE

	if player_state != PlayerState.FLOAT and velocity.y != 0:
		if player_state == PlayerState.JUMP and velocity.y > 0:
			player_state = PlayerState.FALL
		elif player_state != PlayerState.JUMP:
			player_state = PlayerState.FALL
	elif player_state == PlayerState.FLOAT and stats.power <= 0:
		stats.power = 0
		player_state = PlayerState.FALL

	# Using powers
	if player_state == PlayerState.FLOAT:
		stats.power -= FLOAT_COST * _delta

	if Input.is_action_just_pressed("player_fire") or Input.is_action_just_pressed("player_lightning"):
		hold_time = 0.0

	if Input.is_action_pressed("player_fire"):
		hold_elemental = ElementalState.FIRE
		hold_time += 2 * _delta
	elif Input.is_action_pressed("player_lightning"):
		hold_elemental = ElementalState.LIGHTNING
		hold_time += 2 *_delta

	if Input.is_action_just_released("player_fire"):
		create_fire()
		stats.power -= FIRE_COST * min(ceil(hold_time), 3)
	elif Input.is_action_just_released("player_lightning"):
		create_lightning()
		stats.power -= LIGHTNING_COST * min(ceil(hold_time), 3)
		

# Creates multiple lightning blasts
func create_lightning() -> void:
	var scene = preload("res://node/lightning_projectile.tscn")
	for i in range(-min(floor(hold_time), 2), min(ceil(hold_time), 3)):
		var instance = scene.instantiate()
		var rotation_radians = i * PI / 12.0
		var speed = 25*60
		var distance = 32
		var add_vel = velocity
		if player_state != PlayerState.FLOAT:
			add_vel.y = 0

		add_sibling(instance)
		instance.rotate((instance.rotation - rotation_radians) * -facing_direction)
		instance.position = position + Vector2(distance * cos(rotation_radians), distance * sin(rotation_radians)) * facing_direction
		instance.velocity = add_vel + Vector2(speed * cos(rotation_radians), speed * sin(rotation_radians)) * Vector2(facing_direction, 1)
		

# Creates a fireball dependent on the size
func create_fire() -> void:
	var scene = preload("res://node/fire_projectile.tscn")
	var instance = scene.instantiate()
	var add_vel = velocity
	if player_state != PlayerState.FLOAT:
		add_vel.y = 0

	add_sibling(instance)
	instance.position = position + Vector2(32, 0) * facing_direction
	instance.velocity = add_vel + Vector2(75, 0) * Vector2(facing_direction, 1)
	var inst_scale = min(floor(hold_time)+.25, 3)
	instance.scale = Vector2(inst_scale, inst_scale)


func _physics_process(delta):
	# Add the gravity.
	if player_state != PlayerState.FLOAT and not is_on_floor():
		velocity += get_gravity() * delta

	if player_state == PlayerState.FLOAT:
		if vert_direction:
			velocity.y = move_toward(velocity.y, vert_direction * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, FLOAT_DECELERATION * delta)

	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		if player_state == PlayerState.FLOAT:
			velocity.x = move_toward(velocity.x, 0, FLOAT_DECELERATION * delta)
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	if impulse:
		velocity += impulse
		impulse = Vector2()

	move_and_slide()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	pass
