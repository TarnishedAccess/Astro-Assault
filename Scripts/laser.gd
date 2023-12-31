extends Area2D

@export var damage = 1
@export var speed = 600

func _physics_process(delta):
	global_position.y += -speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Drone:
		queue_free()
		area.damage(damage)
		
