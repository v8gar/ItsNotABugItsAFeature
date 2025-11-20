extends Enemy

@onready var dash_timer : Timer = %DashTimer as Timer

@export var moveSpeed : float = 100
@export var dashSpeed : float = 200

var dashTargetPosition : Vector2
var dashDirection : Vector2
var health : int

var state : States = States.TRACKING_PLAYER
enum States {DASHING, TRACKING_PLAYER}

func _physics_process(delta: float) -> void:
	match state:
		States.DASHING:
			pass
		States.TRACKING_PLAYER:
			checkDash()
			move_enemy(delta, moveSpeed)
	
	update_health(health)
	move_and_slide()

func dash() -> void:
	dashTargetPosition = player_location()
	
	await get_tree().create_timer(.5).timeout
	
	dash_timer.start()
	
	dashDirection = global_position.direction_to(dashTargetPosition)
	velocity = dashDirection * dashSpeed * 2	

func checkDash() -> void:
	if global_position.distance_to(player_location()) < 100:
		state = States.DASHING
		dash()

func _on_dash_timer_timeout() -> void:
	state = States.TRACKING_PLAYER
