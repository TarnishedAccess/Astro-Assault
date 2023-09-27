extends Area2D

@export var damage = 1
@export var speed = 600
@export var ROF = 0.25
@export var energy_cost = 10
@onready var laser_sound = $LaserSFX

var player = GlobalVars.player
var game = GlobalVars.game

func _ready():
	player.weapon_ROF = ROF
	player.weapon_energy_cost = energy_cost
	game.energy -= energy_cost
	laser_sound.play()

func _physics_process(delta):
	global_position.y += -speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Drone:
		queue_free()
		area.damage(damage)
		
