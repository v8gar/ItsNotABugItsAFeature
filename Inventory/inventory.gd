class_name Inventory extends Control
## ok this class is pretty unreadable so i'm gonna do my best to document why stuff is happening
## the way it is :)

signal movement_visualization_updated(direction : Vector2)

## [Item] which gets triggered when the inventory is instructed to activate
var active_item : Item
## inactive [Item] held in inventory
var inactive_item : Item

## this variable exists to fix a bug that happens when the player activates the [Item] and then immediately
## switches it before the cooldown starts. Since there's a funky 'await' signal in the [method activate] function,
## we need to know if the active and inactive [Item] have switched so the correct progress bar gets activated
var did_switch : bool = false

## [TextureRect] which displays the active item's icon
@onready var active_item_icon: TextureRect = $MarginContainer/HBoxContainer/ActiveItemIcon
## [TextureRect] which displays the inactive item's icon
@onready var inactive_item_icon: TextureRect = $MarginContainer/HBoxContainer/InactiveItemIcon
## [ProgressBar] which displays the active item's cooldown status
@onready var active_progress_bar: ProgressBar = $MarginContainer/HBoxContainer/ActiveItemIcon/ProgressBar
## [ProgressBar] which displays the inactive item's cooldown status
@onready var inactive_progress_bar: ProgressBar = $MarginContainer/HBoxContainer/InactiveItemIcon/ProgressBar


func _ready() -> void:
	pickup_new_item(load("res://Items/item.tscn"))
	swap_items()
	pickup_new_item(load("res://Items/another_item.tscn"))
	

func _process(_delta: float) -> void:
	# update progres bars with correct values from the items
	active_progress_bar.max_value = active_item.timer.wait_time
	active_progress_bar.value = active_item.timer.wait_time - active_item.timer.time_left
	
	inactive_progress_bar.max_value = inactive_item.timer.wait_time
	inactive_progress_bar.value = inactive_item.timer.wait_time - inactive_item.timer.time_left

## Triggers the active [Item] to run its abilities
func activate():
	did_switch = false
	#if !active_progress_bar.visible:
	active_item.activate()
	await active_item.start_cooldown
	if did_switch:
		inactive_progress_bar.visible = true
	else:
		active_progress_bar.visible = true
	did_switch = false

## Switches the current [member active_item] for the [Item] passed in as an active scene
func pickup_new_item(new_item : PackedScene) -> void:
	var instanced_item : Item = new_item.instantiate() as Item
	if instanced_item is not Item:
		printerr(self, " was instructed to pick up something that was not an item")
		return
	instanced_item.visible = false
	add_child(instanced_item)
	if active_item != null:
		active_item.queue_free()
	active_item = instanced_item
	load_data_from_active_item()


## Switches which [Item] is active vs inactive & updates UI elements to display the appropriate values
func swap_items():
	# disconnecting signals
	if active_item != null:
		active_item.timer.timeout.disconnect(_on_active_item_cooldown_timeout)
	if inactive_item != null:
		inactive_item.timer.timeout.disconnect(_on_inactive_item_cooldown_timeout)
	
	# swapping items
	var item_temp : Item = active_item
	active_item = inactive_item
	inactive_item = item_temp
	
	load_data_from_active_item()
	load_data_from_inactive_item()
	
	var visibility : bool = active_progress_bar.visible
	active_progress_bar.visible = inactive_progress_bar.visible
	inactive_progress_bar.visible = visibility
	
	# notating if a switch happened in case there's that funky await signal in [method activate]
	did_switch = true

## updates UI display and connects signal to correct function
func load_data_from_active_item():
	if active_item == null:
		return
	print('updating move visuals')
	update_movement_visualization()
	active_item_icon.texture = active_item.icon.texture
	active_item.timer.timeout.connect(_on_active_item_cooldown_timeout)

## updates UI display and connects signal to correct function
func load_data_from_inactive_item():
	if inactive_item == null:
		return
	inactive_item_icon.texture = inactive_item.icon.texture
	inactive_item.timer.timeout.connect(_on_inactive_item_cooldown_timeout)

## runs on [member active_item]'s [signal Item.timer.timeout] 
func _on_active_item_cooldown_timeout():
	active_progress_bar.visible = false
	active_progress_bar.value = 0

## runs on [member inactive_item]'s [signal Item.timer.timeout] 
func _on_inactive_item_cooldown_timeout():
	inactive_progress_bar.visible = false
	inactive_progress_bar.value = 0

func update_movement_visualization():
	#var instanced_item : Item = scene.instantiate() as Item
	#if instanced_item is not Item:
		#printerr(self, " was instructed to pick up something that was not an item")
		#return
	#instanced_item.visible = false
	
	#var first_ability = instanced_item.first_ability.instantiate() as Ability
	var first_ability = active_item.first_ability.instantiate() as Ability
	if first_ability is MovementAbility:
		var visualization_dir : Vector2 = first_ability.directions.get(first_ability.direction).rotated(deg_to_rad(90))
		movement_visualization_updated.emit(visualization_dir)
		return
	
	#var second_ability = instanced_item.first_ability.instantiate() as Ability
	var second_ability = active_item.second_ability.instantiate() as Ability
	if second_ability is MovementAbility:
		var visualization_dir : Vector2 = second_ability.directions.get(second_ability.direction).rotated(deg_to_rad(90))
		movement_visualization_updated.emit(visualization_dir)
		return
