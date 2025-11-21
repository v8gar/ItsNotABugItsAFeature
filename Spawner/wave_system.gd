extends Node2D

@onready var enemy_container: Node2D = $EnemyContainer
@onready var spawn_timer: Timer = $SpawnTimer

@onready var round_counter: RichTextLabel = %RoundCounter
@onready var round_progress_bar: ProgressBar = %RoundProgressBar

var wave: int = 0

var spawn_counter: int = 0
var is_done_spawning: bool = false
var prev_wave: int

var health: int = 10
var attack: int
var timer_spawn: float = 3.0
var num_to_spawn: int = 10

var enemy = preload("res://Enemy/Scenes/dash_enemy.tscn")

func _ready() -> void:
	round_progress_bar.value = 0
	round_counter.text = "[center]Round: " + str(wave) + "[/center]"

func finish_round():
	if spawn_counter == num_to_spawn:
		is_done_spawning = true
		spawn_timer.stop()
		
func next_round():
	round_progress_bar.value = 0
	round_counter.text = "[center]Round: " + str(wave) + "[/center]"
	if is_done_spawning == true and enemy_container.get_child_count() == 0:
		# TODO: Dispaly Text on Screen about wave finished
		await wait(3.0)
		# TODO: Display Text on Screen about new wave beginning
		await wait(3.0)
		wave += 1
		spawn_counter = 0
		set_level_stats()
		spawn_timer.start()
		is_done_spawning = false
	
func wait(duration):  
	await get_tree().create_timer(duration, false, false, true).timeout

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
	
	spawn_timer.wait_time = timer_spawn


func _on_spawn_timer_timeout() -> void:
	finish_round()
	next_round()
	
	# Wave manager
	var enemy_instance = enemy.instantiate()
	var spawnpoint = get_tree().get_nodes_in_group("spawn").pick_random()
	
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawnpoint.global_position
	
	spawn_counter += 1


func _on_enemy_container_child_exiting_tree(_node: Node) -> void:
	var enemies_killed : int = spawn_counter - enemy_container.get_children().size()
	round_progress_bar.value = (enemies_killed as float / num_to_spawn as float) * 100
