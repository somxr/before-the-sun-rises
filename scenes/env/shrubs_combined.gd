@tool
extends Node3D

enum PropVariant {
	VARIANT_A,
	VARIANT_B,
	VARIANT_C,
	VARIANT_D,
	VARIANT_E
}

@export var variant: PropVariant = PropVariant.VARIANT_A : set = set_variant
@export_tool_button("Randomize Variant") var randomize_button = randomize_variant
@export_tool_button("Snap to Ground (Y=0)") var snap_button = snap_to_ground

@onready var sprite_3d: Sprite3D = $Sprite3D

func snap_to_ground():
	if Engine.is_editor_hint():
		global_position.y = 0.0
		
func get_texture_for_variant(variant_type: PropVariant) -> Texture2D:
	match variant_type:
		PropVariant.VARIANT_A:
			return preload("uid://gs0pe6i8tg3h")
		PropVariant.VARIANT_B:
			return preload("uid://cteiq1x3v3yub")
		PropVariant.VARIANT_C:
			return preload("uid://cgc5pkyten187")
		PropVariant.VARIANT_D:
			return preload("uid://dle3am2vrwhhn")
		PropVariant.VARIANT_E:
			return preload("uid://berclwlkijujp")
		_:
			return null

func set_variant(value: PropVariant):
	variant = value
	if is_inside_tree() and sprite_3d:
		var current_texture = get_texture_for_variant(variant)
		if current_texture == null:
			return
		
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

func randomize_variant():
	if Engine.is_editor_hint():  # Only works in editor
		var all_variants = [
			PropVariant.VARIANT_A,
			PropVariant.VARIANT_B, 
			PropVariant.VARIANT_C,
			PropVariant.VARIANT_D,
			PropVariant.VARIANT_E
		]
		var random_variant = all_variants[randi() % all_variants.size()]
		set_variant(random_variant)

func _ready():
	set_variant(variant)
