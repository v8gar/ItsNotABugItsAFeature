extends Node2D

var enemy = preload("res://Enemy/Fly_enemy.tscn")
@onready var SpawnTimer: Timer = $SpawnTimer
@onready var EnemyContainer: Node2D = $EnemyContainer

var wave: int = 0

var spawn_counter: int = 0
var is_done_spawning: bool = false
var prev_wave: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	finish_round()
	
	next_round()
		
func finish_round():
	if spawn_counter == num_to_spawn:
		is_done_spawning = true
		SpawnTimer.stop()
		
func next_round():
	if is_done_spawning == true and EnemyContainer.get_child_count() == 0:
		# TODO: Dispaly Text on Screen about wave finished
		await wait(3.0)
		# TODO: Display Text on Screen about new wave beginning
		await wait(3.0)
		wave += 1
		spawn_counter = 0
		set_level_stats()
		SpawnTimer.start()
		is_done_spawning = false
	
func wait(duration):  
	await get_tree().create_timer(duration, false, false, true).timeout

var health: int = 10
var attack: int
var timer_spawn: float = 3.0
var num_to_spawn: int = 10

func set_level_stats() -> void:
		# Stats Blocks every 5 levels
	if 0 <= wave and wave <= 4:
		health = 10
		num_to_spawn = 10
	elif 6 <= wave and wave  <= 9:
		health = 30
		num_to_spawn = 15
	elif 11 <= wave and wave  <= 14:
		health = 50
		num_to_spawn = 20
	
	num_to_spawn += (wave % 5) * 3
	# Level wave stats
	if wave % 5 == 0:
		timer_spawn = 3.0
	elif wave % 5 == 1:
		timer_spawn = 2.0
	elif wave % 5 == 2:
		timer_spawn = 1.0
	elif wave % 5 == 3:
		timer_spawn = 0.7
	elif wave % 5 == 4:
		timer_spawn = 0.3
	
	SpawnTimer.wait_time = timer_spawn


func _on_spawnTimer_timeout() -> void:
	# Wave manager
	var enemy_instance = enemy.instantiate()
	EnemyContainer.add_child(enemy_instance)
	enemy_instance.position = $SpawnLocation.position
	
	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes[randi()%nodes.size()]
	var position1 = node.position
	$SpawnLocation.position = position1
	spawn_counter += 1
