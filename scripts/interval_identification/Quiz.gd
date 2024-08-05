class_name Quiz
extends Node

var rng = RandomNumberGenerator.new()

var scoreNode
var streakNode
var endScreenStatsNode
var endScreenhighestStreakNode
var quizPageNode
var endPageNode

var validIntervals
var numberQuestions
var fixedRoot
var playingOrder

var intervalDic = {'P1': 0, 'm2': 1, 'M2': 2, 'm3': 3, 'M3': 4, 'P4': 5, 'TT': 6, 'P5': 7, 'm6': 8, 'M6': 9, 'm7': 10, 'M7': 11, 'P8': 12}

var notesSounds = [preload("res://assets/piano-notes-sounds/0-A3.mp3"), preload("res://assets/piano-notes-sounds/1-Bb3.mp3"), preload("res://assets/piano-notes-sounds/2-B3.mp3"), preload("res://assets/piano-notes-sounds/3-C3.mp3"), preload("res://assets/piano-notes-sounds/4-Db3.mp3"), preload("res://assets/piano-notes-sounds/5-D3.mp3"), preload("res://assets/piano-notes-sounds/6-Eb3.mp3"), preload("res://assets/piano-notes-sounds/7-E3.mp3"), preload("res://assets/piano-notes-sounds/8-F3.mp3"), preload("res://assets/piano-notes-sounds/9-Gb3.mp3"), preload("res://assets/piano-notes-sounds/10-G3.mp3"), preload("res://assets/piano-notes-sounds/11-Ab3.mp3"), preload("res://assets/piano-notes-sounds/12-A4.mp3"), preload("res://assets/piano-notes-sounds/13-Bb4.mp3"), preload("res://assets/piano-notes-sounds/14-B4.mp3"), preload("res://assets/piano-notes-sounds/15-C4.mp3"), preload("res://assets/piano-notes-sounds/16-Db4.mp3"), preload("res://assets/piano-notes-sounds/17-D4.mp3"), preload("res://assets/piano-notes-sounds/18-Eb4.mp3"), preload("res://assets/piano-notes-sounds/19-E4.mp3"), preload("res://assets/piano-notes-sounds/20-F4.mp3"), preload("res://assets/piano-notes-sounds/21-Gb4.mp3"), preload("res://assets/piano-notes-sounds/22-G4.mp3"), preload("res://assets/piano-notes-sounds/23-Ab4.mp3"), preload("res://assets/piano-notes-sounds/24-A5.mp3"), preload("res://assets/piano-notes-sounds/25-Bb5.mp3"), preload("res://assets/piano-notes-sounds/26-B5.mp3"), preload("res://assets/piano-notes-sounds/27-C5.mp3"), preload("res://assets/piano-notes-sounds/28-Db5.mp3"), preload("res://assets/piano-notes-sounds/29-D5.mp3"), preload("res://assets/piano-notes-sounds/30-Eb5.mp3"), preload("res://assets/piano-notes-sounds/31-E5.mp3"), preload("res://assets/piano-notes-sounds/32-F5.mp3"), preload("res://assets/piano-notes-sounds/33-Gb5.mp3"), preload("res://assets/piano-notes-sounds/34-G5.mp3"), preload("res://assets/piano-notes-sounds/35-Ab5.mp3")]

var currentInterval

# {interval: [asked, correct]}
var quizResults = {'total': [0, 0], 'streak': 0, 'highestStreak': 0, 'P1': [0, 0], 'm2': [0, 0], 'M2': [0, 0], 'm3': [0, 0], 'M3': [0, 0], 'P4': [0, 0], 'TT': [0, 0], 'P5': [0, 0], 'm6': [0, 0], 'M6': [0, 0], 'm7': [0, 0], 'M7': [0, 0], 'P8': [0, 0]}

func init(scoreNodeInput, streakNodeInput, endScreenStatsNodeInput, endScreenhighestStreakNodeInput, quizPageNodeInput, endPageNodeInput, validIntervalsInput, numberQuestionsInput, fixedRootInput, playingOrderInput):
	scoreNode = scoreNodeInput
	streakNode = streakNodeInput
	endScreenStatsNode = endScreenStatsNodeInput
	endScreenhighestStreakNode = endScreenhighestStreakNodeInput
	quizPageNode = quizPageNodeInput
	endPageNode = endPageNodeInput
	
	match validIntervalsInput:
		0: # simple
			validIntervals = ['P1', 'M3', 'P5', 'P8']
		1: # diatonic
			validIntervals = ['P1', 'M2', 'M3', 'P4', 'P5', 'M6', 'M7', 'P8']
		2: # all
			validIntervals = ['P1', 'm2', 'M2', 'm3', 'M3', 'P4', 'TT', 'P5', 'm6', 'M6', 'm7', 'M7', 'P8']
	
	numberQuestions = numberQuestionsInput
	
	fixedRoot = [fixedRootInput]
	if fixedRoot[0]:
		var root = rng.randi_range(0, 22) # (inclusive)
		fixedRoot.append(root) # set fixedroot starting note to 
	
	match playingOrderInput:
		0:
			playingOrder = 'asending'
		1:
			playingOrder = 'desending'
		2:
			playingOrder = 'simultaneous'
	
	update_score_streak()
	
	print(validIntervals)
	print(numberQuestions)
	print(fixedRoot)
	print(playingOrder)
	
func generate_question():
	var interval = validIntervals.pick_random()
	var intervalSemitones = intervalDic[interval]
	var intervalNotes = []
	
	if fixedRoot[0]:
		intervalNotes.append(fixedRoot[1])
		intervalNotes.append((fixedRoot[1] + intervalSemitones))
	else:
		intervalNotes.append(rng.randi_range(0, (35-intervalSemitones)))
		intervalNotes.append((intervalNotes[0] + intervalSemitones))
		
	print('Interval: {} ({} to {})'.format([interval, intervalNotes[0], intervalNotes[1]], "{}"))
	
	# [interval, # of semitones in interval, notes (by index) making up interval, if question has been answered incorrectly
	currentInterval = [interval, intervalSemitones, intervalNotes, false]
	
func play_interval(audioPlayer, audioPlayer2, intervalNotes):
	print(intervalNotes)
	match playingOrder:
		'asending':
			audioPlayer.stream = notesSounds[intervalNotes[0]]
			audioPlayer.play()
			await audioPlayer.finished
			audioPlayer.stream = notesSounds[intervalNotes[1]]
			audioPlayer.play()
		'desending':
			audioPlayer.stream = notesSounds[intervalNotes[1]]
			audioPlayer.play()
			await audioPlayer.finished
			audioPlayer.stream = notesSounds[intervalNotes[0]]
			audioPlayer.play()
		'simultaneous':
			audioPlayer.stream = notesSounds[intervalNotes[0]]
			audioPlayer2.stream = notesSounds[intervalNotes[1]]
			audioPlayer.play()
			audioPlayer2.play()
			
func check_guess(guess):
	if guess == currentInterval[0]:
		if !currentInterval[3]:
			print('correct')
			# add to all results thingies
			quizResults['total'][0] += 1
			quizResults['total'][1] += 1
			quizResults[currentInterval[0]][0] += 1
			quizResults[currentInterval[0]][1] += 1
			print('current results: ', quizResults)
			quizResults['streak'] += 1
			
			# update score and streak
			update_score_streak()
			
			if numberQuestions != 0:
				if quizResults['total'][0] == numberQuestions:
					print('question limit reached')
					end_quiz()
		else:
			print('correct but previously incorrect')
			print('current results: ', quizResults)
			
		generate_question()
			
	else:
		print('incorrect')
		currentInterval[3] = true
		quizResults['total'][0] += 1 # add to to
		quizResults[currentInterval[0]][0] += 1
		
		if quizResults['highestStreak'] <= quizResults['streak']: # update highest streak before reseting
			quizResults['highestStreak'] = quizResults['streak']
		quizResults['streak'] = 0
		
		# update score and streak
		update_score_streak()
		
		if numberQuestions != 0:
				if quizResults['total'][0] == numberQuestions:
					print('question limit reached')
					end_quiz()

func update_score_streak():
	scoreNode.text = '[center]{} of {} correct[/center]'.format([quizResults['total'][1], quizResults['total'][0]], '{}')
	streakNode.text = '[center]Streak of {} correct[/center]'.format([quizResults['streak']], '{}')

func end_quiz():
	# add incorrect if final question is answered incorrectly
	if currentInterval[3]:
		quizResults['total'][0] += 1 # add to to
		quizResults[currentInterval[0]][0] += 1
		print('current results: ', quizResults)
		if quizResults['highestStreak'] <= quizResults['streak']: # update highest streak before reseting
			quizResults['highestStreak'] = quizResults['streak']
		quizResults['streak'] = 0
			
	# update end screen
	var percentScore = float( (float(quizResults['total'][1])) / float((quizResults['total'][0])) *100 )
	percentScore = round(percentScore * 100) / 100.0 # round to 2 decimals
	endScreenStatsNode.text = '[center]You successfully identified {} of {} correctly, or {}%[/center]'.format([quizResults['total'][1], quizResults['total'][0], str(percentScore)], '{}')
	endScreenhighestStreakNode.text = '[center]Highest Streak: {}[/center]'.format([quizResults['highestStreak']], '{}')
	
	quizPageNode.hide()
	endPageNode.show()
