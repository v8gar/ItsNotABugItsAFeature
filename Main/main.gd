extends Node2D

var enemy = preload("res://Enemy/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_spawnTimer_timeout() -> void:
	
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	enemy_instance.position = $SpawnLocation.position
	
	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes[randi()%nodes.size()]
	var position1 = node.position
	$SpawnLocation.position = position1
