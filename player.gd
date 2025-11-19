class_name Player extends CharacterBody2D

signal player_died

const SPEED: int = 200
var click_position = Vector2()
var target_position = Vector2()

@onready var inventory: Inventory = $CanvasLayer/Inventory
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var move_vis_rotation_helper: Node2D = $MoveVisRotationHelper
@onready var movement_visualization: Node2D = $MoveVisRotationHelper/MovementVisualization

@export var hitbox : HitBox
@export var item : PackedScene

var instanced_item : Item = null

func _ready() -> void:
	player_died.connect(get_parent().player_died)
	inventory.movement_visualization_updated.connect(update_movement_visualization)
	inventory.update_movement_visualization()

func _process(delta: float) -> void:
	move_vis_rotation_helper.look_at(get_global_mouse_position())
	
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
	animation_tree.set("parameters/Idle/blend_position", velocity.normalized())
	animation_tree.set("parameters/Walk/blend_position", velocity.normalized())

func die():
	player_died.emit()

func update_movement_visualization(dir : Vector2):
	print("instructed to update rotation")
	movement_visualization.rotation = dir.angle()
