extends Control

@onready var name_label = $Verdict/NameLabel
@onready var guilty_button = $Verdict/GuiltyButton  
@onready var innocent_button = $Verdict/InnocentButton
@onready var result_label = $Verdict/ResultLabel
@onready var score_label = $Verdict/ScoreLabel
@onready var timer_label = $Verdict/TimerLabel
@onready var game_over_panel = $Verdict/GameOverPanel
@onready var exit_button = $Verdict/ExitButton

var names_pool = [
	"maria", "john", "jane", "jasmine", "paco", "pablo",
	"marco", "andy", "matthew", "julie", "sophie", "sophia",
	"daphne", "daisy", "catherine", "maddie", "shelby",
	"derek", "pammy", "peggy", "eliza", "angelica"
]

var current_person = ""
var guilt_probability = 0.0
var score = 0
var round_count = 0
var max_rounds = 15
var time_left = 5.0
var game_active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	setup_ui()
	start_new_game()
	if exit_button:
		exit_button.pressed.connect(_on_exit_pressed)

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/intro/office_intro/office_intro.tscn")

func setup_ui():
	if guilty_button:
		guilty_button.focus_mode = Control.FOCUS_NONE
		guilty_button.mouse_filter = Control.MOUSE_FILTER_STOP
	if innocent_button:
		innocent_button.focus_mode = Control.FOCUS_NONE  
		innocent_button.mouse_filter = Control.MOUSE_FILTER_STOP
	if exit_button:
		exit_button.focus_mode = Control.FOCUS_NONE
		exit_button.mouse_filter = Control.MOUSE_FILTER_STOP
	
	result_label.visible = false
	game_over_panel.visible = false
	
	guilty_button.pressed.connect(_on_guilty_pressed)
	innocent_button.pressed.connect(_on_innocent_pressed)
	
	score_label.text = "dolla: 0"
	
func start_new_game():
	score = 0
	round_count = 0
	game_active = true
	next_person()

func next_person():
	if round_count >= max_rounds:
		end_game()
		return
	
	current_person = names_pool[randi() % names_pool.size()]
	guilt_probability = randf_range(0.15, 0.85)

	name_label.text = current_person
	result_label.visible = false
	timer_label.text = "Time: 5"
	
	guilty_button.disabled = false
	innocent_button.disabled = false
	
	time_left = 5.0
	round_count += 1
	
func _process(delta):
	if not game_active:
		return
		
	time_left -= delta
	timer_label.text = "Time: " + str(int(time_left + 1))
	
	if time_left <= 0:
		timeout()

func _on_guilty_pressed():
	make_verdict(true)

func _on_innocent_pressed():
	make_verdict(false)

func make_verdict(player_says_guilty: bool):
	if not game_active:
		return
		
	guilty_button.disabled = true
	innocent_button.disabled = true
	
	var roll = randf()
	var actually_guilty = roll < guilt_probability
	
	var player_correct = (player_says_guilty == actually_guilty)
	
	var points = 0
	if player_correct:
		points = 10
		score += points
	else:
		points = -5
		score += points
	
	var result_text = ""
	if actually_guilty:
		result_text = current_person + " committed tax fraud. "
	else:
		result_text = current_person + " ran a boba shop. "
	
	if player_correct:
		result_text += "yay! (+" + str(points) + ")"
	else:
		result_text += "aww! (" + str(points) + ")"
	
	result_label.text = result_text
	result_label.visible = true
	score_label.text = "dolla: " + str(score)
	
	await get_tree().create_timer(1).timeout
	next_person()

func timeout():
	if not game_active:
		return
		
	game_active = false
	
	guilty_button.disabled = true
	innocent_button.disabled = true
	
	score -= 10
	result_label.text = current_person + " - TIME'S UP! (-10 points)"
	result_label.visible = true
	score_label.text = "dolla: " + str(score)
	
	await get_tree().create_timer(1.0).timeout
	next_person()

func end_game():
	game_active = false
	
	var rating = get_score_rating()
	var final_text = "< final verdict >\n\ndolla: " + str(score) + "/" + str(max_rounds * 10)
	final_text += "\n\nrating: " + rating
	
	game_over_panel.get_node("FinalScoreLabel").text = final_text
	game_over_panel.visible = true

func get_score_rating() -> String:
	if score >= 120:
		return "PERFECT\ngj brotha"
	elif score >= 90:
		return "EXCELLENT\nfire"
	elif score >= 60:
		return "GOOD\ncool"
	elif score >= 30:
		return "AVERAGE\nmid"
	elif score >= 0:
		return "POOR\ni will consider firing you"
	else:
		return "BORDERLINE TERRIBLE\nyou are out of a job"

func restart_game():
	game_over_panel.visible = false
	start_new_game()
