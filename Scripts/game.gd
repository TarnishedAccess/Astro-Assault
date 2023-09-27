extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var gem_scenes: Array[PackedScene] = []
@export var difficulty = 0
@export var difficulty_ramp = 1
@export var minimum_spawn_time = 0.5
@export var initial_spawn_time = 2

@export var max_energy = 100
@export var energy_regen = 0.15

@onready var player_spawn = $Spawn
@onready var laser_container = $LaserContainer
@onready var spawn_timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UI/HUD
@onready var gameover = $UI/GameOver
@onready var paraback = $ParallaxBackground
@onready var game_music = $Game_music
@onready var pause = $UI/Pause
@onready var drop_container = $DropContainer

@onready var pickup_sound = $SFX/Pickup_Sound
@onready var playerdie_sound = $SFX/PlayerDie
@onready var playerlaser_sound = $SFX/PlayerLaser
@onready var dronedie_sound = $SFX/DroneDie

var player = null

var score := 0:
	set(value):
		score = value
		hud.score = score
		
var highscore
var scroll_speed = 100
var timer = 0.0
var energy = max_energy

var credits = 0:
	set(value):
		credits = value
		hud.currency = credits

# Called when the node enters the scene tree for the first time.
func _ready():
	var save = FileAccess.open("user://save.data", FileAccess.READ)
	if save!=null:
		highscore = save.get_32()
	else:
		highscore = 0
		save_state()
			
	score = 0
	credits = 0
	player = get_tree().get_first_node_in_group("Player")
	player.global_position = player_spawn.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.died.connect(_on_player_died)
	game_music.play(GlobalVars.music_progress)
	spawn_timer.wait_time = initial_spawn_time

func save_state():
	var save = FileAccess.open("user://save.data", FileAccess.WRITE)
	save.store_32(highscore)

func timer_function(time):
	time = int(time)
	var minutes = time / 60
	var seconds = time - (minutes * 60)
	hud.timer = "%02d:%02d" % [minutes, seconds]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = true
		pause.visible = true
	
	paraback.scroll_offset.y += delta * scroll_speed
	if paraback.scroll_offset.y >= 720:
		paraback.scroll_offset.y = 0

	energy += energy_regen
	energy = clamp(energy, 0, max_energy)
	hud.energy = energy

	timer += delta
	timer_function(timer)

	difficulty = timer * difficulty_ramp
	
	spawn_timer.wait_time  = initial_spawn_time - (difficulty * 0.01)
	spawn_timer.wait_time = clamp(spawn_timer.wait_time, minimum_spawn_time, initial_spawn_time)
	
func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	playerlaser_sound.play()

func _on_enemy_spawn_timer_timeout():
	var new_enemy = enemy_scenes.pick_random().instantiate()
	new_enemy.global_position = Vector2(randf_range(50, 490), -40)
	new_enemy.killed.connect(_on_enemy_killed)
	new_enemy.gem_spawn.connect(_on_enemy_gem_spawn)
	enemy_container.add_child(new_enemy)

func _on_enemy_killed(score_value):
	dronedie_sound.play()
	score += score_value
	
func _on_enemy_gem_spawn(Y, X, credit_value):
	var new_gem = gem_scenes[0].instantiate()
	new_gem.value = credit_value
	new_gem.collected.connect(_on_gem_collected)
	new_gem.global_position = Vector2(X, Y)
	drop_container.add_child(new_gem)
	
func _on_player_died():
	playerdie_sound.play()
	gameover.set_score(score)
	if score > highscore:
		highscore = score
	gameover.set_highscore(highscore)
	save_state()
	await get_tree().create_timer(1).timeout
	gameover.visible = true

func _on_game_over_restart():
	GlobalVars.music_progress = game_music.get_playback_position() + 0.02
	#Adding 0.02s to make up for the very small time it takes to transition. I feel like this makes the music smoother.
	get_tree().reload_current_scene()

func _on_gem_collected(value):
	credits += value
	pickup_sound.play()

func _on_player_fire_attempt(energy_cost):
	if energy_cost <= energy:
		player.shoot()
		energy -= energy_cost
		
