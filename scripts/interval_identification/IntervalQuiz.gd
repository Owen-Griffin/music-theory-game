extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_interval_quiz_pressed():
	$"../ConfigPage".hide()
	$".".show()
	
func _on_hear_question_pressed():
	pass # Replace with function body.
	
func _on_end_quiz_pressed():
	$".".hide()
	$"../EndPage".show()
