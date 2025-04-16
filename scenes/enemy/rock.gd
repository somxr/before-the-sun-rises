extends CharacterBody3D

@export var speed := 14.0
@export var lifetime := 3.0 
var direction := Vector3.ZERO

@export var gravity_strength := 6.0
var vertical_velocity := 0.0

@onready var hitbox: Hitbox = $hitbox
@onready var timer: Timer = $Timer

@onready var impact_particles: GPUParticles3D = $impactParticles
@onready var impact_sound: AudioStreamPlayer3D = $impactSound


func _ready():
	timer.wait_time = lifetime
	timer.start()

func _physics_process(delta: float) -> void:
	# Set velocity based on direction and speed
	velocity = direction * speed
	
	# Apply gravity influence
	vertical_velocity += gravity_strength * delta
	velocity.y -= vertical_velocity
	
	# Move and check for collisions
	var collision = move_and_slide()
	
	# If we hit something with the CharacterBody3D itself
	if get_slide_collision_count() > 0:
		handle_collision(get_slide_collision(0).get_collider())

# Call this when the projectile hits something
func handle_collision(collider):
	print("Hit: ", collider.name)
	# Apply damage if the collider has a health component
	if collider.has_method("take_damage"):
		collider.take_damage(1)  # Or whatever damage value
	
	
		# Play sound effect
	if impact_sound:
		# Reparent to keep sound playing after rock is freed
		var scene_root = get_tree().get_root()
		remove_child(impact_sound)
		scene_root.add_child(impact_sound)
		
		# Position sound at impact location
		impact_sound.global_transform.origin = global_transform.origin
		
		# Play the sound
		impact_sound.play()
		
		# Set up timer to free the sound after it finishes playing
		var sound_cleanup_timer = Timer.new()
		impact_sound.add_child(sound_cleanup_timer)
		sound_cleanup_timer.wait_time = impact_sound.stream.get_length() + 0.5  # Add small buffer
		sound_cleanup_timer.one_shot = true
		sound_cleanup_timer.timeout.connect(func(): impact_sound.queue_free())
		sound_cleanup_timer.start()
	
		# Play impact particles
	if impact_particles:
		# Reparent to keep particles alive after rock is freed
		var scene_root = get_tree().get_root()
		remove_child(impact_particles)
		scene_root.add_child(impact_particles)
		
		# Position particles at current location
		impact_particles.global_transform.origin = global_transform.origin
		
		# Trigger particles
		impact_particles.emitting = true
		
		# Set up particles to free themselves after emission
		if not impact_particles.one_shot:
			impact_particles.one_shot = true
		
		# Create a timer to free the particles after they're done
		var cleanup_timer = Timer.new()
		impact_particles.add_child(cleanup_timer)
		cleanup_timer.wait_time = impact_particles.lifetime + 0.5  # Add a small buffer
		cleanup_timer.one_shot = true
		cleanup_timer.timeout.connect(func(): impact_particles.queue_free())
		cleanup_timer.start()
	
	# Destroy the projectile
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()  # Remove when lifetime expires
