class_name AttackAbility extends Ability

@export var hurt_box : HurtBox
@export var sprite : AnimatedSprite2D

func enable_hurt_box():
	if hurt_box != null:
		hurt_box.enable()

func disable_hurt_box():
	if hurt_box != null:
		hurt_box.disable()

func start_sprite_anim():
	if sprite != null:
		sprite.play()
