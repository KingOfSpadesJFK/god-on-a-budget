extends Camera2D

@export var follow_node_path: NodePath
var following: bool
var follow_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	follow_node = get_node(follow_node_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if following:
	# 	position = position.lerp(follow_node.position, 0.1)
	# 	if position.distance_to(follow_node.position) < 1:
	# 		following = false
	position = position.lerp(follow_node.position, 0.1)


func _on_player_exited(body: Node2D) -> void:
	print("Exited")
	if body == follow_node:
		following = true
