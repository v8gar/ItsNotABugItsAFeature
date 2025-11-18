class_name Enemy
extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("players")[0]
@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D as NavigationAgent2D
@onready var hit_box: HitBox = $HitBox

@export var healthbar : ProgressBar

var nextPoint : Vector2
var direction : Vector2

func _physics_process(delta: float) -> void:
	move_enemy(delta, 100)

func move_enemy(delta : float, movement_speed: float) -> void:
	navigation_agent_2d.target_position = player.global_position
	
	nextPoint = navigation_agent_2d.get_next_path_position()
	direction = global_position.direction_to(nextPoint)
	
	velocity = lerp(velocity, direction * movement_speed, delta * 12)
	
	#move_to_destination(delta)
	
func move_to_destination(delta : float) -> void:
	global_position += velocity * delta

func player_location() -> Vector2:
	return player.global_position
	
func die():
	self.queue_free()

func update_health(health : int):
	health = hit_box.health_component.health
	healthbar.max_value = hit_box.health_component.max_health
	healthbar.value = health
	if health >= hit_box.health_component.max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
	var current_percentage = ((healthbar.value - healthbar.min_value) / (healthbar.max_value - healthbar.min_value)) * 100
	var sb = healthbar.get("theme_override_styles/fill")
	if sb == null:
		sb = StyleBoxFlat.new()
		healthbar.add_theme_stylebox_override("fill", sb)
	
	if current_percentage >= 70:
		sb.bg_color = Color('#8ab060')
	elif current_percentage >= 30:
		sb.bg_color = Color('#d3a068')
	else:
		sb.bg_color = Color('#b45252')

	
	
