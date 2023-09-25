class_name Drone extends Area2D

@export var hp = 1
@export var speed = 135
@export var score_value = 100
@export var gem_chance = 50
@export var credit_value = 1

@onready var dronehit_sound = $SFX/DroneHit

signal killed
signal gem_spawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position.y += speed * delta
	global_position.x += randf_range(-speed/5, speed/5) * delta

func damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(score_value)
		die()
	else:
		dronehit_sound.play()

func die():
	if randi_range(0, 100) >= gem_chance:
		gem_spawn.emit(global_position.y, global_position.x, credit_value)
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.die()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
