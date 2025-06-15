@tool
extends Node3D


enum PropVariant {
	SMALL_ROCK,
	MEDIUM_ROCK,
	MEDIUM_ROCK2,
	BIG_ROCK
}

@export var variant: PropVariant = PropVariant.SMALL_ROCK : set = set_variant
@export_tool_button("Randomize Variant") var randomize_button = randomize_variant
@export_tool_button("Snap to Ground (Y=0)") var snap_button = snap_to_ground

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

# Cleaner data structure with meaningful keys
var rock_variants = {
	# Key (enum value) : Value (another dictionary)
	PropVariant.SMALL_ROCK: {
		texture = preload("uid://3lddm2t18u71"),
		collision_size = Vector3(0.731, 1.0, 0.826),
		collision_offset = Vector3(0.017, 0.575, -0.048),
		sprite_height = 0.334
	},
	PropVariant.MEDIUM_ROCK: {
		texture = preload("uid://c1dtdbvbo4cpg"),
		collision_size = Vector3(1.0, 1.0, 1.0),
		collision_offset = Vector3(0.018, 0.575, 0.039),
		sprite_height = 0.676
	},
	PropVariant.MEDIUM_ROCK2: {
		texture = preload("uid://detnp8fsqft58"),
		collision_size = Vector3(1.0, 1.0, 1.0),
		collision_offset = Vector3(0.018, 0.575, 0.039),
		sprite_height = 0.594
	},
	PropVariant.BIG_ROCK: {
		texture = preload("uid://btf3sh6thulmn"),
		collision_size = Vector3(1.272, 1.072, 1.377),
		collision_offset = Vector3(0.083, 0.539, -0.001),
		sprite_height = 0.765
	}
}

func _ready():
	set_variant(variant)

func snap_to_ground():
	if Engine.is_editor_hint():
		global_position.y = 0.0

func randomize_variant():
	if Engine.is_editor_hint():
		var all_variants = rock_variants.keys()
		var random_variant = all_variants[randi() % all_variants.size()]
		set_variant(random_variant)

func set_variant(value: PropVariant):
	variant = value
	if not is_inside_tree() or not sprite_3d:
		return
		
	var data = rock_variants.get(variant)
	if not data:
		push_error("Unknown rock variant: " + str(variant))
		return
	
	_update_sprite(data)
	_update_material(data.texture)
	_update_collision(data)

# Separate function for sprite updates - easier to read
func _update_sprite(data: Dictionary):
	sprite_3d.texture = data.texture
	sprite_3d.position.y = data.sprite_height

# Separate function for material setup - cleaner logic
func _update_material(texture: Texture2D):
	var material = sprite_3d.material_override
	
	if material == null:
		material = _create_default_material()
		sprite_3d.material_override = material
	else:
		# IMPORTANT: Make the material unique so it doesn't affect other instances
		material = material.duplicate()
		sprite_3d.material_override = material
	
	# Update textures
	material.albedo_texture = texture
	material.backlight_texture = texture

# Separate function for collision setup - much cleaner
func _update_collision(data: Dictionary):
	if not collision_shape:
		return
		
	var box_shape = collision_shape.shape
	
	# Create or duplicate collision shape
	if box_shape == null or not box_shape is BoxShape3D:
		box_shape = BoxShape3D.new()
	else:
		box_shape = box_shape.duplicate()
	
	# Apply collision data
	box_shape.size = data.collision_size
	collision_shape.shape = box_shape
	collision_shape.position = data.collision_offset

# Helper function for default material creation
func _create_default_material() -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	material.backlight_enabled = true
	material.backlight = Color.WHITE
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(0.5, 0.5, 0.5, 1.0)
	return material
