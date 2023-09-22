extends Control

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/ScoreText.text = "Score: " + str(value)
	
func set_highscore(value):
	$Panel/HighScoreText.text = "High-Score: " + str(value)
	
