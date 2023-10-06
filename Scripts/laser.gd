extends Area2D

#IM GOING INSANE
#WHAT IS HAPPENING

#POLICEMEN SWEAR TO GOD
#LOVE'S SEEPING FROM THE GUNS
#I KNOW MY FRIENDS AND I
#WOULD PROBABLY TURN AND RUN
#IF YOU GET OUT OF BED
#COME FIND US HEADING FOR THE BRIDGE
#BRING A STONE
#ALL THE RAGE
#MY LITTLE DARK AGE
#I BREATHE IN STEREO
#THE STEREO SOUNDS STRANGE
#I KNOW THAT IF YOU HIDE
#IT DOESNT GO AWAY
#IF YOU GET OUT OF BED
#AND FIND MY STANDING ALL ALONE
#OPEN EYED BURN THE PAGE
#MY LITTLE DARK AGE


@export var damage = 1.0
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
		
