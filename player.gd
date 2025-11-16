class_name Player extends CharacterBody2D

const SPEED: int = 200
var click_position = Vector2()
var target_position = Vector2()

@onready var inventory: Inventory = $CanvasLayer/Inventory

@export var hitbox : HitBox
@export var item : PackedScene

var instanced_item : Item = null

#func _ready() -> void:
	#inventory.pickup_new_item(load("res://Items/item.tscn"))

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
		inventory.activate()
	
	if Input.is_action_just_pressed("switch_item"):
		inventory.swap_items()
	
	move_and_slide()
