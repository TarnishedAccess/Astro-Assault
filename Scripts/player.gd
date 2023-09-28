class_name Player extends CharacterBody2D

signal weapon_shot(weapon_scene, location)
signal died
signal fire_attempt

@export var speed = 300
@onready var gunmuzzle = $GunMuzzle

@export var weapon_ROF : float
@export var weapon_energy_cost : float
@export var weapon_scene = load("res://Scenes/laser.tscn")
var shoot_CD = false

func _ready():
	GlobalVars.player = self

func _process(delta):
	if Input.is_action_pressed("Shoot"):
		if !shoot_CD:
			fire_attempt.emit(weapon_energy_cost)

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("Move_left", "Move_right"), Input.get_axis("Move_up", "Move_down"))
	velocity = direction * speed
	move_and_slide()
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
func shoot():
	shoot_CD = true
	weapon_shot.emit(weapon_scene, gunmuzzle.global_position)
	await(get_tree().create_timer(weapon_ROF).timeout)
	shoot_CD = false
	
func die():
	died.emit()
	queue_free()
