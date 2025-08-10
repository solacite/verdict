extends Control

@onready var name_label = $NameLabel
@onready var guilty_button = $GuiltyButton  
@onready var innocent_button = $InnocentButton
@onready var result_label = $ResultLabel
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel
@onready var game_over_panel = $GameOverPanel

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
	setup_ui()

func setup_ui():
	result_label.visible = false
	game_over_panel.visible = false
	
	score_label.text = "Score: 0"
