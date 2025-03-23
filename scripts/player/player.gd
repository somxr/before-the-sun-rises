extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5

var walking = false
var running = false

@onready var animation_player: AnimationPlayer = $visuals/playerModel/AnimationPlayer
@onready var visuals: Node3D = $visuals


func _ready() -> void:
	print("we do get ready")
	#set the duration of the blend time when going from the idle animation to walking animation
	animation_player.set_blend_time("idle", "run", 0.2)
	animation_player.set_blend_time("run","idle", 0.2)

	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	# I had the direction working based on the world transform basis
	# since the camera's rotated 45 degrees, I want to rotate all the input by 45 degrees counter clockwise also
	# using the rotation matrix multiplication explained at the top of this wikipedia page 
	# https://en.wikipedia.org/wiki/Rotation_matrix 
	# lazy solution, would be better to actually reference the camera and calculate the correct directions no matter what way it's rotated
	var rotated_input = Vector2(
	input_dir.x * cos(deg_to_rad(-45)) - input_dir.y * sin(deg_to_rad(-45)),
	input_dir.x * sin(deg_to_rad(-45)) + input_dir.y * cos(deg_to_rad(-45))
	)
	var direction := (transform.basis * Vector3(rotated_input.x, 0, rotated_input.y)).normalized()
	
	
	
	#WALKING LOGIC
	#when a direction is detected you can start walking
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		visuals.look_at(direction+position)
		
		#if the state was not already "walking" when a direction is input, 
		#then change state to walking
		if !running:
			running = true
			animation_player.play("run")
			
	else: 
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if running:
			running = false
			animation_player.play("idle")


	move_and_slide()
