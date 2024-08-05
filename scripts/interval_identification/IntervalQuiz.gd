extends Node2D

var IntervalQuiz = preload("res://scripts/interval_identification/Quiz.gd")
var currentQuestion = []
var quiz

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_interval_quiz_pressed():
	$"../ConfigPage".hide()
	$".".show()
	
	# begin quiz
	quiz = IntervalQuiz.new()
	# pass config info
	quiz.init($Score, $Streak, $"../EndPage/Score", $"../EndPage/Highest Streak", $".", $"../EndPage", $"../ConfigPage/IntervalSelector".selected, $"../ConfigPage/QuestionSelector".value, $"../ConfigPage/FixedRootSelector".button_pressed, $"../ConfigPage/OrderSelector".selected)
	
	# enable interval buttons
	var buttons = [$SelectButtons/P1, $SelectButtons/m2, $SelectButtons/Maj2, $SelectButtons/m3, $SelectButtons/Maj3, $SelectButtons/P4, $SelectButtons/TT, $SelectButtons/P5, $SelectButtons/m6, $SelectButtons/Maj6, $SelectButtons/m7, $SelectButtons/Maj7, $SelectButtons/P8]
	for interval in quiz.validIntervals:
		match interval:
			'P1':
				$SelectButtons/P1.disabled = false
			'm2':
				$SelectButtons/m2.disabled = false
			'M2':
				$SelectButtons/Maj2.disabled = false
			'm3':
				$SelectButtons/m3.disabled = false
			'M3':
				$SelectButtons/Maj3.disabled = false
			'P4':
				$SelectButtons/P4.disabled = false
			'TT':
				$SelectButtons/TT.disabled = false
			'P5':
				$SelectButtons/P5.disabled = false
			'm6':
				$SelectButtons/m6.disabled = false
			"M6":
				$SelectButtons/Maj6.disabled = false
			'm7':
				$SelectButtons/m7.disabled = false
			'M7':
				$SelectButtons/Maj7.disabled = false
			'P8':
				$SelectButtons/P8.disabled = false
	
	quiz.generate_question()

func _on_hear_question_pressed():
	quiz.play_interval($AudioPlayer, $AudioPlayer2, quiz.currentInterval[2])
	pass # Replace with function body.
	
func _on_end_quiz_pressed():
	quiz.end_quiz()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
func _on_p_1_pressed():
	quiz.check_guess('P1')
func _on_m_2_pressed():
	quiz.check_guess('m2')
func _on_maj_2_pressed():
	quiz.check_guess('M2')
func _on_m_3_pressed():
	quiz.check_guess('m3')
func _on_maj_3_pressed():
	quiz.check_guess('M3')
func _on_p_4_pressed():
	quiz.check_guess('P4')
func _on_tt_pressed():
	quiz.check_guess('TT')
func _on_p_5_pressed():
	quiz.check_guess('P5')
func _on_m_6_pressed():
	quiz.check_guess('m6')
func _on_maj_6_pressed():
	quiz.check_guess('M6')
func _on_m_7_pressed():
	quiz.check_guess('m7')
func _on_maj_7_pressed():
	quiz.check_guess('M7')
func _on_p_8_pressed():
	quiz.check_guess('P8')

func _on_restart_button_pressed():
	currentQuestion = []
	quiz = 'none'
	$"../EndPage".hide()
	$"../ConfigPage".show()
