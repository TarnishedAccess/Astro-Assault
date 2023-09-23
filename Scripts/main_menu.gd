extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@onready var spawn_timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var game = preload("res://Scenes/game.tscn")
@onready var menu_music = $MenuMusic

func _ready():
	menu_music.play(0.5)

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().quit()
		
func _on_enemy_spawn_timer_timeout():
	var new_enemy = enemy_scenes.pick_random().instantiate()
	new_enemy.global_position = Vector2(randf_range(50, 490), -40)
	enemy_container.add_child(new_enemy)

func _on_button_pressed():
	get_tree().change_scene_to_packed(game)
