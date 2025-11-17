class_name Enemy
extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("players")[0]
@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D as NavigationAgent2D

var nextPoint : Vector2
var direction : Vector2

func _physics_process(delta: float) -> void:
	move_enemy(delta, 100)

func move_enemy(delta : float, movement_speed: float) -> void:
	navigation_agent_2d.target_position = player.global_position
	
	nextPoint = navigation_agent_2d.get_next_path_position()
	direction = global_position.direction_to(nextPoint)
	
	velocity = direction * movement_speed
	
	move_to_destination(delta)
	
func move_to_destination(delta : float) -> void:
	global_position += velocity * delta

func player_location() -> Vector2:
	return player.global_position
	
func die():
	self.queue_free()
