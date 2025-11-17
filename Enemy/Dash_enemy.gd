extends Enemy

@onready var dash_timer: Timer = %DashTimer as Timer

@export var moveSpeed : float = 100
@export var dashSpeed : float = 400.0

var dashTargetPosition: Vector2
var isDashing : bool
var dashDirection : Vector2
var isDashQueued = false

func _physics_process(delta: float) -> void:
	if dash_timer.is_stopped():
		checkDash()
		if isDashing:
			dash(delta)
		else:
			move_enemy(delta, moveSpeed)

func dash(delta: float) -> void:
	if isDashQueued:
		return   
	else:
		dashTargetPosition = player_location()
	
	isDashQueued = true
	await get_tree().create_timer(1).timeout
	isDashQueued = false
	
	dash_timer.start()
	
	dashDirection = global_position.direction_to(dashTargetPosition)
	velocity = dashDirection * dashSpeed
	
	global_position += (velocity * delta) * 10

func checkDash() -> void:
	if global_position.distance_to(player_location()) < 150:
		if not isDashing:
			isDashing = true
	else:
		isDashing = false

func _on_DashTimer_timeout():
	isDashing = false
