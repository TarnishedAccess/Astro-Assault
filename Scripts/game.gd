extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

@onready var player_spawn = $Spawn
@onready var laser_container = $LaserContainer
@onready var spawn_timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UI/HUD
@onready var gameover = $UI/GameOver
@onready var paraback = $ParallaxBackground

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

# Called when the node enters the scene tree for the first time.
func _ready():
	var save = FileAccess.open("user://save.data", FileAccess.READ)
	if save!=null:
		highscore = save.get_32()
	else:
		highscore = 0
		save_state()
			
	score = 0
	player = get_tree().get_first_node_in_group("Player")
	player.global_position = player_spawn.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.died.connect(_on_player_died)

func save_state():
	var save = FileAccess.open("user://save.data", FileAccess.WRITE)
	save.store_32(highscore)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
		
	spawn_timer.wait_time -= delta * 0.01
	spawn_timer.wait_time = clamp(spawn_timer.wait_time, 0.5, 2)
	
	paraback.scroll_offset.y += delta * scroll_speed
	if paraback.scroll_offset.y >= 720:
		paraback.scroll_offset.y = 0
	
func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	playerlaser_sound.play()

func _on_enemy_spawn_timer_timeout():
	var new_enemy = enemy_scenes.pick_random().instantiate()
	new_enemy.global_position = Vector2(randf_range(50, 490), -40)
	new_enemy.killed.connect(_on_enemy_killed)
	enemy_container.add_child(new_enemy)

func _on_enemy_killed(score_value):
	dronedie_sound.play()
	score += score_value
	
	
func _on_player_died():
	playerdie_sound.play()
	gameover.set_score(score)
	if score > highscore:
		highscore = score
	gameover.set_highscore(highscore)
	save_state()
	await get_tree().create_timer(1).timeout
	gameover.visible = true
