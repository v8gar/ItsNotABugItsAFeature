class_name MovementAbility extends Ability

var directions : Dictionary[int, Vector2] = {
	0 : Vector2.LEFT,
	1 : Vector2.RIGHT,
	2 : Vector2.UP,
	3 : Vector2.DOWN
}
enum Directions {LEFT = 0, RIGHT = 1, UP = 2, DOWN = 3}

@export var direction : Directions
@export var power : float

var player : Player

func with_data(new_player : Player):
	if new_player != null:
		player = new_player
	return self

func enable_player_hitbox():
	if player != null:
		player.hitbox.enable()

func disable_player_hitbox():
	if player != null:
		player.hitbox.disable()

func apply_velocity_to_player():
	if player != null:
		player.velocity += directions.get(direction).rotated(self.global_rotation).rotated(deg_to_rad(90)) * power * 250
