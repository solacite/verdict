extends CanvasLayer

@onready var to_computer_label = $to_computer

func animate_text():
	# Set label's starting position
	var final_y_pos = to_computer_label.position.y
	to_computer_label.position.y = final_y_pos - 100

	# Make label transparent
	to_computer_label.modulate.a = 0.0
	
	await get_tree().create_timer(0.8).timeout

	var tween = create_tween()
	tween.set_parallel(true)
	
	# From initial Y to the final Y
	tween.tween_property(to_computer_label, "position:y", final_y_pos, 1)

	# Tween opacity
	tween.tween_property(to_computer_label, "modulate:a", 1.0, 1.5)

func _ready():
	animate_text()
