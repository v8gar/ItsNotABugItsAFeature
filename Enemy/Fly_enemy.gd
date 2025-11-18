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
