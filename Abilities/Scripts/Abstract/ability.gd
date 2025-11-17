@abstract class_name Ability extends Node2D

@warning_ignore("unused_signal") signal finished

@export var ability_anim : AnimationPlayer
@export var cooldown : float

func _ready() -> void:
	ability_anim.play("Start")
	ability_anim.animation_finished.connect(end)
	look_at(get_global_mouse_position())

#func _process(delta: float) -> void:
	#look_at(get_global_mouse_position())

func end(_anim_name : String):
	finish()
	queue_free()

func finish():
	finished.emit()
