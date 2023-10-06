class_name Player extends CharacterBody2D

signal weapon_shot(weapon_scene, location)
signal died
signal fire_attempt
signal boost_attempt

@export var max_speed = 600
@export var min_speed = 100
@export var base_speed = 200
@export var boost_cost = 0.5

var speed = base_speed:
	set(value):
		speed = value
		if speed > max_speed:
			speed = max_speed
		elif speed < min_speed:
			speed = min_speed
			
@onready var gunmuzzle = $GunMuzzle
@onready var particle_1 = $GPUParticles2D
@onready var particle_2 = $GPUParticles2D2

@export var weapon_ROF : float
@export var weapon_energy_cost : float
@export var weapon_scene = load("res://Scenes/chaingun.tscn")
var shoot_CD = false

func _ready():
	GlobalVars.player = self

func _process(delta):
	print(speed)
	if Input.is_action_pressed("Shoot"):
		if !shoot_CD:
			fire_attempt.emit(weapon_energy_cost)
	if Input.is_action_pressed("Boost"):
		boost_attempt.emit(boost_cost)
		boost()
	if Input.is_action_just_released("Boost"):
		release_boost()


func _physics_process(delta):
	var direction = Vector2(Input.get_axis("Move_left", "Move_right"), Input.get_axis("Move_up", "Move_down"))
	velocity = direction * speed
	move_and_slide()
	#global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size + Vector2(50, -50))
	global_position.x = clamp(global_position.x, 50, 490)
	global_position.y = clamp(global_position.y, 20, 700)
	
func boost():
	speed += 5
	speed = clamp(speed, base_speed, base_speed*2)
	particle_1.process_material.color = "eeffe260"
	
func release_boost():
	speed = base_speed
	particle_1.process_material.color = "ffffa116"
	
func shoot():
	shoot_CD = true
	weapon_shot.emit(weapon_scene, gunmuzzle.global_position)
	await(get_tree().create_timer(weapon_ROF).timeout)
	shoot_CD = false
	
func die():
	died.emit()
	queue_free()
