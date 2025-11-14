@abstract class_name Ability extends Node

@warning_ignore("unused_signal") signal finished

@export var ability_anim : AnimationPlayer
@export var cooldown : float

func _ready() -> void:
	ability_anim.play("Start")
	ability_anim.animation_finished.connect(end)

func end(_anim_name : String):
	finish()
	queue_free()

func finish():
	finished.emit()
