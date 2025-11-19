class_name Item extends Node

signal start_cooldown

@export var icon : Sprite2D
@export var first_ability : PackedScene
@export var second_ability : PackedScene
@onready var timer: Timer = $Timer

## Cooldown for an item is the maximum cooldown of the abilities it activates
var cooldown : int
var player : Player
var is_running : bool = false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0] as Player

func activate():
	if !timer.is_stopped() || is_running:
		return
	is_running = true
	cooldown = 0
	
	var first_action = activate_ability(first_ability)
	cooldown = first_action.cooldown
	await first_action.finished
	
	var second_action =  activate_ability(second_ability)
	cooldown = max(second_action.cooldown, cooldown)
	await second_action.finished
	#print(cooldown)
	is_running = false
	timer.start(cooldown)
	start_cooldown.emit()

func activate_ability(ability : PackedScene) -> Ability:
	var activated_ability : Ability = ability.instantiate() as Ability
	if activated_ability is MovementAbility:
		activated_ability.with_data(player)
	player.add_child(activated_ability)
	return activated_ability
