class_name gem_yellow_small extends Area2D

signal collected
var value = 1
var speed = -4
var rotation_direction = randi()%2
#Gem randomly rotates to the left or the right. Does nothing but looks better I think

func _physics_process(delta):
	speed += delta * 4
	if speed > 6:
		speed = 6
	global_position.y += speed
	if rotation_direction:
		rotation += 2 * delta
	else:
		rotation += -2 * delta

func _on_body_entered(body):
	if body is Player:
		collected.emit(value)
		queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
