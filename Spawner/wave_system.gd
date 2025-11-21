extends Node2D

@onready var enemy_container: Node2D = $EnemyContainer
@onready var spawn_timer: Timer = $SpawnTimer

@onready var round_counter: RichTextLabel = %RoundCounter
@onready var round_progress_bar: ProgressBar = %RoundProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var splash_screen_text: RichTextLabel = %SplashScreenText
@onready var splash_screen: Control = %SplashScreen

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
	splash_screen.modulate.a = 0
	round_progress_bar.value = 0
	round_counter.text = "[center]Round: " + str(wave) + "[/center]"
	set_level_stats()
	play_splash_screen()

func finish_round():
	print("End of round ", wave)
	spawn_timer.stop()
	

func update_round_counter():
	round_counter.text = "[center]Round: " + str(wave) + "[/center]"
	round_progress_bar.value = 0

func play_splash_screen():
	splash_screen_text.text = "[center][shake]Round: " + str(wave)
	animation_player.play("RoundSplashScreen")
	await animation_player.animation_finished

func next_round():
	wave += 1
	await play_splash_screen()
	spawn_counter = 0
	set_level_stats()
	spawn_timer.start()
	is_done_spawning = false
	print("Start of round ", wave)


func set_level_stats() -> void:
		# Stats Blocks every 5 levels
	if 0 <= wave and wave <= 4:
		health = 10
		num_to_spawn = 3
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
	if spawn_counter == num_to_spawn:
		if enemy_container.get_children().size() == 0:
			finish_round()
			next_round()
		return
	# Wave manager
	var enemy_instance = enemy.instantiate()
	var spawnpoint = get_tree().get_nodes_in_group("spawn").pick_random()
	
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawnpoint.global_position
	
	spawn_counter += 1


func _on_enemy_container_child_exiting_tree(killed_enemy: Node) -> void:
	await killed_enemy.tree_exited
	var enemies_killed : int = spawn_counter - enemy_container.get_children().size()
	round_progress_bar.value = (enemies_killed as float / num_to_spawn as float) * 100
