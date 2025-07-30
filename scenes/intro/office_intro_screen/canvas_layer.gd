extends CanvasLayer

# Get nodes and store them in variables
@onready var top_rect = $TopRect
@onready var bot_rect = $BottomRect
@onready var main_text = $MainText
@onready var small_text = $SmallText

# Main function! Automatically called
func _ready():
	# Make rects opaque
	top_rect.modulate.a = 1.0
	bot_rect.modulate.a = 1.0
	main_text.modulate.a = 0.0
	small_text.modulate.a = 0.0
	
	# Start with text hidden & invisible
	main_text.visible = false
	small_text.visible = false
	
	var viewport_height = get_viewport().get_visible_rect().size.y
	
	# Close eyes
	top_rect.position.y = 0
	bot_rect.position.y = viewport_height / 2
	
	# Fade in main text
	main_text.visible = true
	await fade_in_text(main_text, 1.0)

	await get_tree().create_timer(0.5).timeout

	# Fade in small text
	small_text.visible = true
	await fade_in_text(small_text, 1.0)

	# Fade out text
	await get_tree().create_timer(1).timeout
	var fade_out_tween = create_tween()
	fade_out_tween.set_parallel(true)
	fade_out_tween.tween_property(main_text, "modulate:a", 0.0, 1.0)
	fade_out_tween.tween_property(small_text, "modulate:a", 0.0, 1.0)
	await fade_out_tween.finished
	
	# Load next scene
	var next_scene = preload("res://scenes/intro/office_intro/office_intro.tscn")
	var scene_instance = next_scene.instantiate()
	get_parent().add_child(scene_instance)
	get_parent().move_child(scene_instance, get_parent().get_children().find(self))

	
	# Blink!
	await open_eyes()

# Open sesame
func open_eyes() -> void:
	var viewport_height = get_viewport().get_visible_rect().size.y
	var tween = create_tween()
	tween.set_parallel(true)

	# Open eyes
	tween.tween_property(top_rect, "position:y", -top_rect.get_rect().size.y, 0.7)
	tween.tween_property(bot_rect, "position:y", viewport_height, 0.7)

	await tween.finished

# Fade-in text
func fade_in_text(label_node: CanvasItem, duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(label_node, "modulate:a", 1.0, duration)
	await tween.finished

# Fade-out text
func fade_out_text(label_node: CanvasItem, duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(label_node, "modulate:a", 0.0, duration)
	await tween.finished
