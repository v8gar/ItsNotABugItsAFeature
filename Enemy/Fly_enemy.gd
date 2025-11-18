extends Enemy

func _physics_process(delta: float) -> void:
	move_enemy(delta, 100)

func update_health():
	var healthbar = $HealthBar
	var health = hit_box.health_component.health
	healthbar.max_value = hit_box.health_component.max_health
	healthbar.value = health
	if health >= hit_box.health_component.max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true
	
	var stylebox = healthbar.get("theme_override_colors/fill")
	print(stylebox)
	
	var current_percentage = ((healthbar.value - healthbar.min_value) / (healthbar.max_value - healthbar.min_value)) * 100
	if current_percentage >= 70:
		healthbar.set_modulate(Color('#8ab060'))
	elif current_percentage >= 30:
		healthbar.set_modulate(Color('#d3a068'))
	else:
		healthbar.set_modulate(Color('#b45252'))
