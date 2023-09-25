extends Control

@onready var score = $Score_Display:
	set(value):
		score.text = "Score = " + str(value)

@onready var timer = $Timer_Display:
	set(value):
		timer.text = str(value)

@onready var currency = $Currency_Display:
	set(value):
		currency.text = "Credits = " + str(value)
