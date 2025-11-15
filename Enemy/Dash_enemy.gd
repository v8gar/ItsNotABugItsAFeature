extends Enemy

@onready var dash_timer: Timer = %DashTimer as Timer

@export var move_speed : float = 100
@export var dash_speed : float = 400.0

var isDashing : bool
var dash_direction : Vector2

func _physics_process(delta: float) -> void:
	checkDash()
	if dash_timer.is_stopped():
		if isDashing:
			dash(delta)
		else:
			move_enemy(delta, move_speed)

func dash(delta: float) -> void:
	dash_timer.start()
	
	dash_direction = global_position.direction_to(player_location())
	velocity = dash_direction * dash_speed
	
	global_position+= (velocity * delta) * 10

func checkDash() -> void:
	if global_position.distance_to(player_location()) < 100:
		isDashing = true
	else:
		isDashing = false

func _on_DashTimer_timeout():
	isDashing = false
