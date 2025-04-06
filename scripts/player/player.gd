extends CharacterBody3D


@export var run_speed = 12.0
const JUMP_VELOCITY = 4.5

var direction = Vector3(0,0,0)

# state variables
var running = false
var dashing = false

#Dash variables
@export var dash_cooldown_duration = 0.5 #cool down duration in seconds
var dash_cooldown_timer = 0.0 
var dash_speed = 40.0    # How fast the dash moves
var dash_duration = 0.2 # How long the dash lasts in seconds
var dash_timer = 0.0     # Counts down to keep track of ending dash
var dash_direction = Vector3.ZERO  # Stores the locked dash direction

var dash_delay = 0.05        # Delay before reaching full speed (in seconds)

#attack variables
var attack_recovery = 0.0
var attack_momentum = 1.75
var current_attack_momentum = 0.0

var last_input_direction = Vector3(0,0,0)

#Health variables
var health:= 3

#this is the visual skin of the Player
@onready var aiden_model: Node3D = $AidenModel
@onready var brenna_model: Node3D = $brennaModel

func get_rotated_isometric_direction(input_dir) -> Vector3:
	# I had the direction working based on the world transform basis since the camera's rotated 45 degrees, I want to rotate all the input by 45 degrees counter clockwise also
	# using the rotation matrix multiplication explained at the top of this wikipedia page. This is lazier than actually referencing the camera to find the direction relative to it
	# https://en.wikipedia.org/wiki/Rotation_matrix 
	var rotated_input = Vector2(
	input_dir.x * cos(deg_to_rad(-45)) - input_dir.y * sin(deg_to_rad(-45)),
	input_dir.x * sin(deg_to_rad(-45)) + input_dir.y * cos(deg_to_rad(-45))
	)
	return (transform.basis * Vector3(rotated_input.x, 0, rotated_input.y)).normalized()

func _ready() -> void:
	add_to_group("player")
	#set the duration of the blend time when going from the idle animation to walking animation
	#animation_player.set_blend_time("idle", "run", 0.2)
	#animation_player.set_blend_time("run","idle", 0.2)

func handle_dashing(delta, direction):
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	#if the dash was just input this frame and dash ability is cooled down to 0
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		dashing=true
		dash_cooldown_timer = dash_cooldown_duration 
		dash_timer = dash_duration + dash_delay
		dash_direction = last_input_direction
	
	# Update dash timer if in the middle of a dash
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false

func take_damage(damage: int) -> void:
	print("OUCH")
	health -= 1
	
	if health <= 0:
		print("you died")

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
	
	if not dashing:
		direction = get_rotated_isometric_direction(input_dir)
	
	if direction != Vector3(0,0,0):
		last_input_direction = direction
	
	handle_dashing(delta, direction)
	
	# Movement based on state (dashing or normal)
	if dashing and dash_timer<dash_duration:
		# When dashing, move faster in the saved dash direction
		velocity.x = dash_direction.x * dash_speed
		velocity.z = dash_direction.z * dash_speed
		aiden_model.look_at(dash_direction + position)
		brenna_model.look_at(dash_direction + position)
	else: #normal running movement
		#WALKING LOGIC: when a direction is detected you can start walking
		if direction:
			velocity.x = direction.x * run_speed
			velocity.z = direction.z * run_speed
			
			aiden_model.look_at(direction+position)
			brenna_model.look_at(direction+position)
			#if the state was not already "walking" when a direction is input, 
			#then change state to walking
			if !running:
				running = true
				#animation_player.play("run")
				
		else:
			velocity.x = 0
			velocity.z = 0
			#if no direction detected but the state is running then the player just stopped moving so we update the state
			if running:
				running = false
				#animation_player.play("idle")

	move_and_slide()



	
	
	
