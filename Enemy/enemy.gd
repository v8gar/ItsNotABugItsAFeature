class_name Enemy
extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var movement_speed: float = 1.0
var new_velocity: Vector2

@onready var player = get_tree().get_nodes_in_group("players")[0]



func _process(delta: float) -> void:
	moveEnemy()
	
func moveEnemy():
	navigation_agent_2d.set_target_position(player.global_position)
	velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position()) * movement_speed
	move_to_destination(velocity)
	
func move_to_destination(velocity : Vector2):
	global_position = global_position.move_toward(global_position + velocity, movement_speed)
	
	
