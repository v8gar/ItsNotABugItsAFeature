extends Enemy

var health : int

func _physics_process(delta: float) -> void:
	move_and_slide()
	move_enemy(delta, 100)
	update_health(health)
