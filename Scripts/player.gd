class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)
signal died
signal fire_attempt

@export var speed = 300
@export var ROF = 0.25
@export var energy_cost = 10

@onready var gunmuzzle = $GunMuzzle

var laser_scene = preload("res://Scenes/laser.tscn")
var shoot_CD = false

func _process(delta):
	if Input.is_action_pressed("Shoot"):
		if !shoot_CD:
			fire_attempt.emit(energy_cost)

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("Move_left", "Move_right"), Input.get_axis("Move_up", "Move_down"))
	velocity = direction * speed
	move_and_slide()
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
func shoot():
	shoot_CD = true
	laser_shot.emit(laser_scene, gunmuzzle.global_position)
	await(get_tree().create_timer(ROF).timeout)
	shoot_CD = false
	
func die():
	died.emit()
	queue_free()
