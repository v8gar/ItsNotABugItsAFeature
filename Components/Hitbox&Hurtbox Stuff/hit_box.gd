class_name HitBox extends Area2D

@export var health_component : HealthComponent
@export var collision_shape2D : CollisionShape2D
@export var hit_effect : PackedScene

func _ready() -> void:
	health_component.die.connect(die)

func enable() -> void:
	collision_shape2D.disabled = false

func disable() -> void:
	collision_shape2D.disabled = true

func do_hit_effect() -> void:
	if hit_effect != null:
		add_child(hit_effect.instantiate())

func _on_area_entered(area: Area2D) -> void:
	
	if area is not HurtBox:
		return
	
	do_hit_effect()
	
	if health_component != null:
		health_component.take_damage((area as HurtBox).do_attack())

func die():
	# TODO: change ts, should not be hardcoded to enemy only
	if get_parent() is Enemy:
		get_parent().queue_free()
	else:
		self.queue_free()
