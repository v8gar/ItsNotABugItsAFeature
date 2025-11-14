class_name Item extends Node

@export var icon : Sprite2D
@export var first_ability : PackedScene
@export var second_ability : PackedScene

var player : Player

func with_data(new_player : Player):
	player = new_player
	return self

func activate():
	await activate_ability(first_ability).finished
	await activate_ability(second_ability).finished

func activate_ability(ability : PackedScene) -> Ability:
	var activated_ability : Ability = ability.instantiate() as Ability
	if activated_ability is MovementAbility:
		activated_ability.with_data(player)
	player.add_child(activated_ability)
	return activated_ability
