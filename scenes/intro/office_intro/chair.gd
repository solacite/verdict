extends Node

@onready var sit_label = $Area3D/sit_label
@onready var interaction_progress = $Area3D/SubViewport/Control/TextureProgressBar

var hold_timer = 0.0
const HOLD_DURATION = 1.5

func _ready():
	interaction_progress.visible = false
	sit_label.visible = false
	set_process(false)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "ProtoController":
		interaction_progress.visible = true
		sit_label.visible = true
		set_process(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "ProtoController":
		interaction_progress.value = 0
		interaction_progress.visible = false
		sit_label.visible = false
		hold_timer = 0.0
		set_process(false)

func _process(delta):
	var camera = get_viewport().get_camera_3d()

	if camera:
		# Vector3.UP keeps text upright
		sit_label.look_at(camera.global_position, Vector3.UP, true)
	
	if Input.is_action_pressed("interact"):
		hold_timer += delta
		# Calculate the progress from 0 to 100
		interaction_progress.value = (hold_timer / HOLD_DURATION) * 100
		
		# If the hold duration is reached, sit down!
		if hold_timer >= HOLD_DURATION:
			sit_down()
	# Reset the timer and progress if the button is released
	elif Input.is_action_just_released("interact"):
		hold_timer = 0.0
		interaction_progress.value = 0

func sit_down():
	# Hide the UI elements
	sit_label.visible = false
	interaction_progress.visible = false
	
	# Load the next scene (your cutscene)
	#get_tree().change_scene_to_file("res://scenes/cutscene/computer_cutscene.tscn")
