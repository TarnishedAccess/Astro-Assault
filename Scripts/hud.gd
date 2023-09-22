extends Control

@onready var score = $Score_Display:
	set(value):
		score.text = "Score = " + str(value)
