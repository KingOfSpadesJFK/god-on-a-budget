extends RichTextLabel

var player_path = "/root/Control/SubViewportContainer/SubViewport/World/Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var health = get_parent().get_node(player_path).stats.health
	var power = get_parent().get_node(player_path).stats.power

	text = "Health: " + str(snapped(health, 1)) + "\nFire: " + str(snapped(power, 0.01))
