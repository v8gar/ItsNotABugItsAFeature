class_name Player extends CharacterBody2D

signal player_died

const SPEED: int = 200
var click_position = Vector2()
var target_position = Vector2()

@onready var inventory: Inventory = $CanvasLayer/Inventory
@onready var animation_tree: AnimationTree = $AnimationTree

@export var hitbox : HitBox
@export var item : PackedScene

var instanced_item : Item = null

func _ready() -> void:
	player_died.connect(get_parent().player_died)

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("left_click"):
		target_position = (get_global_mouse_position() - global_position).normalized()
		if (get_global_mouse_position() - global_position).length() > 5:
			velocity = lerp(velocity, target_position * SPEED, 12 * delta)
		else:
			velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 12 * delta)
	if Input.is_action_just_pressed("ui_accept"):
		hitbox.health_component.take_damage(100)
	if Input.is_action_just_pressed("right_click"):
		inventory.activate()
	
	if Input.is_action_just_pressed("switch_item"):
		inventory.swap_items()
	
	move_and_slide()
	update_anim_parameters()

func update_anim_parameters():
	if velocity:
		animation_tree.set("parameters/conditions/idle", false)
		animation_tree.set("parameters/conditions/walk", true)
	else:
		animation_tree.set("parameters/conditions/idle", true)
		animation_tree.set("parameters/conditions/walk", false)
	animation_tree.set("parameters/Idle/blend_position", velocity.normalized())
	animation_tree.set("parameters/Walk/blend_position", velocity.normalized())

func die():
	player_died.emit()
