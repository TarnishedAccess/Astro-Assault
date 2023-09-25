class_name gem_yellow_small extends Area2D

signal collected

@export var value = 1
var speed = -4

func _physics_process(delta):
	speed += delta * 4
	if speed > 6:
		speed = 6
	global_position.y += speed

func _on_body_entered(body):
	if body is Player:
		collected.emit(value)
		queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
