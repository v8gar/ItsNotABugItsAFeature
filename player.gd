class_name Player extends CharacterBody2D

const SPEED: int = 200
var click_position = Vector2()
var target_position = Vector2()
@export var ability : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		target_position = (get_global_mouse_position() - global_position).normalized()
		if (get_global_mouse_position() - global_position).length() > 5:
			velocity = lerp(velocity, target_position * SPEED, 12 * delta)
		else:
			velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("right_click"):
		add_child(ability.instantiate())
	
	move_and_slide()

func die():
	queue_free()
