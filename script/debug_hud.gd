extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var health = get_parent().get_node("Player").player_stats.health
	var fire = get_parent().get_node("Player").player_stats.fire_power
	var lightning = get_parent().get_node("Player").player_stats.lightning_power
	var air = get_parent().get_node("Player").player_stats.air_power

	text = "Health: " + str(health) + "\nFire: " + str(fire) + "\nLightning: " + str(lightning) + "\nAir: " + str(air)
