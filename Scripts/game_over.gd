extends Control
signal restart
signal quit

func _on_restart_button_pressed():
	restart.emit()

func set_score(value):
	$Panel/ScoreText.text = "Score: " + str(value)
	
func set_highscore(value):
	$Panel/HighScoreText.text = "High-Score: " + str(value)

func _on_quit_button_pressed():
	#quit.emit()
	get_tree().quit()
