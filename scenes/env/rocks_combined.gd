@tool
extends Node3D

enum PropVariant {
	VARIANT_A,
	VARIANT_B,
	VARIANT_C,
	VARIANT_D
}

@export var variant: PropVariant = PropVariant.VARIANT_A : set = set_variant
@export_tool_button("Randomize Variant") var randomize_button = randomize_variant
@export_tool_button("Snap to Ground (Y=0)") var snap_button = snap_to_ground

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D  # Adjust this path to match your scene structure

# Store both texture and collision dimensions together
var rock_data = {
	PropVariant.VARIANT_A: {
		"texture": preload("uid://c1dtdbvbo4cpg"),
		"collision_size": Vector3(1.0, 1.0, 1.0),  # width, height, depth
		"collision_position": Vector3(0.018, 0.575,0.039)
	},
	PropVariant.VARIANT_B: {
		"texture": preload("uid://3lddm2t18u71"),
		"collision_size": Vector3(0.731, 1.0, 0.826),
		"collision_position": Vector3(0.017, 0.575,-0.048)
	},
	PropVariant.VARIANT_C: {
		"texture": preload("uid://detnp8fsqft58"),
		"collision_size": Vector3(1.0, 1.0, 1.0),
		"collision_position": Vector3(0.018, 0.575,0.039)
	},
	PropVariant.VARIANT_D: {
		"texture": preload("uid://btf3sh6thulmn"),
		"collision_size": Vector3(1.272, 1.072, 1.377),
		"collision_position": Vector3(0.083, 0.539,-0.001)
	}
}

func snap_to_ground():
	if Engine.is_editor_hint():
		global_position.y = 0.0
		
func get_texture_for_variant(variant_type: PropVariant) -> Texture2D:
	var data = rock_data.get(variant_type)
	if data:
		return data.texture
	return null

func set_variant(value: PropVariant):
	variant = value
	if is_inside_tree() and sprite_3d:
		var data = rock_data.get(variant)
		if data == null:
			return
		
		var current_texture = data.texture
		var collision_size = data.collision_size
		var collision_position = data.collision_position
		
		# Always set the main sprite texture
		sprite_3d.texture = current_texture
		
		# Get or create the material override
		var material = sprite_3d.material_override
		if material == null:
			material = StandardMaterial3D.new()
			sprite_3d.material_override = material
			# Only set defaults for new materials
			material.backlight_enabled = true
			material.backlight = Color.WHITE
			material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			material.albedo_color = Color(0.5,0.5,0.5,1)
		else:
			# IMPORTANT: Make the material unique so it doesn't affect other instances
			material = material.duplicate()
			sprite_3d.material_override = material
		
		# Always update textures
		material.albedo_texture = current_texture
		material.backlight_texture = current_texture
		
		# Update collision box dimensions
		if collision_shape:
			var box_shape = collision_shape.shape
			if box_shape == null or not box_shape is BoxShape3D:
				# Create new BoxShape3D if none exists
				box_shape = BoxShape3D.new()
				collision_shape.shape = box_shape
			else:
				# Make it unique so it doesn't affect other instances
				box_shape = box_shape.duplicate()
				collision_shape.shape = box_shape
				
			# Set the collision box size
			box_shape.size = collision_size
			collision_shape.position = collision_position

func randomize_variant():
	if Engine.is_editor_hint():  # Only works in editor
		var all_variants = [
			PropVariant.VARIANT_A,
			PropVariant.VARIANT_B, 
			PropVariant.VARIANT_C,
			PropVariant.VARIANT_D
		]
		var random_variant = all_variants[randi() % all_variants.size()]
		set_variant(random_variant)

func _ready():
	set_variant(variant)
