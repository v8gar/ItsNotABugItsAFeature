class_name Ability extends Node

@export var attack_animation: AnimatedSprite2D
@export var hurt_box : HurtBox

func _ready() -> void:
	attack_animation.play()

func _on_sprite_2d_animation_finished() -> void:
	attack_animation.stop()
	attack_animation.visible = false
	await get_tree().create_timer(0.2).timeout
	self.queue_free()
