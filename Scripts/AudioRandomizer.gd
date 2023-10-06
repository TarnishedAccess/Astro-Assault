extends AudioStreamPlayer2D

func _ready():
	randomize()
	pitch_scale = randf_range(0.7, 1.3)	
