class_name gem_yellow_small extends Area2D

signal collected
var value = 1
var speed = randf_range(-1, -4)
var angular_speed = randf_range(-0.5, 0.5)
var rotation_direction = randi()%2
#Gem randomly rotates to the left or the right. Does nothing but looks better I think

func _physics_process(delta):
	speed += delta * 4
	if speed > 6:
		speed = 6
	global_position.y += speed
	global_position.x += angular_speed
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
