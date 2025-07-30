extends MeshInstance3D

# Reference SubViewport node
@onready var ui_viewport = $"../SubViewport"

func _ready():
	var material = self.get_surface_override_material(0)
	
	# Get texture from SubViewport and assign it to the albedo texture
	if material and ui_viewport:
		material.albedo_texture = ui_viewport.get_texture()
