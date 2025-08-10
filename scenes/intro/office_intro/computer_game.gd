extends Control

@onready var name_label = $Verdict/NameLabel
@onready var guilty_button = $Verdict/GuiltyButton  
@onready var innocent_button = $Verdict/InnocentButton
@onready var result_label = $Verdict/ResultLabel
@onready var score_label = $Verdict/ScoreLabel
@onready var timer_label = $Verdict/TimerLabel
@onready var game_over_panel = $Verdict/GameOverPanel

var names_pool = [
	"maria", "john", "jane", "jasmine", "paco", "pablo",
	"marco", "andy", "matthew", "julie", "sophie", "sophia",
	"daphne", "daisy", "catherine", "maddie", "shelby"
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

func setup_ui():
	result_label.visible = false
	game_over_panel.visible = false
	
	guilty_button.pressed.connect(_on_guilty_pressed)
	innocent_button.pressed.connect(_on_innocent_pressed)
	
	score_label.text = "Score: 0"
	
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
		result_text = current_person + " was GUILTY! "
	else:
		result_text = current_person + " was INNOCENT! "
	
	if player_correct:
		result_text += "You were RIGHT! (+" + str(points) + ")"
	else:
		result_text += "You were WRONG! (" + str(points) + ")"
	
	result_label.text = result_text
	result_label.visible = true
	score_label.text = "Score: " + str(score)
	
	next_person()

func timeout():
	guilty_button.disabled = true
	innocent_button.disabled = true
	
	score -= 10
	result_label.text = current_person + " - TIME'S UP! (-10 points)"
	result_label.visible = true
	score_label.text = "Score: " + str(score)
	
	await get_tree().create_timer(2.0).timeout
	next_person()

func end_game():
	game_active = false
	
	var rating = get_score_rating()
	var final_text = "FINAL VERDICT:\n\nScore: " + str(score) + "/" + str(max_rounds * 10)
	final_text += "\n\nRating: " + rating
	
	game_over_panel.get_node("FinalScoreLabel").text = final_text
	game_over_panel.visible = true

func get_score_rating() -> String:
	if score >= 120:
		return "PERFECT JUDGE\ngj brotha"
	elif score >= 90:
		return "EXCELLENT JUDGE\nfire"
	elif score >= 60:
		return "GOOD JUDGE\ncool"
	elif score >= 30:
		return "AVERAGE JUDGE\nmid"
	elif score >= 0:
		return "POOR JUDGE\ni will consider firing you"
	else:
		return "TERRIBLE JUDGE\nyou are out of a job"

func restart_game():
	game_over_panel.visible = false
	start_new_game()
