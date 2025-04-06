extends CharacterBody3D

@export var speed := 14.0
@export var lifetime := 3.0 
var direction := Vector3.ZERO

@export var gravity_strength := 6.0
var vertical_velocity := 0.0

@onready var hitbox: Hitbox = $hitbox
@onready var timer: Timer = $Timer

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
	
	# Play impact effect
	# spawn_impact_effect()
	
	# Destroy the projectile
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()  # Remove when lifetime expires
