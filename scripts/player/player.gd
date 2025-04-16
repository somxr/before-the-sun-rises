extends CharacterBody3D


@export var run_speed = 12.0
const JUMP_VELOCITY = 4.5

var direction = Vector3(0,0,0)

# state variables
var running = false
var dashing = false
var hurt = false
var dead = false
var won = false

#Dash variables
@export var dash_cooldown_duration = 0.5 #cool down duration in seconds
var dash_cooldown_timer = 0.0 
@export var dash_speed = 20.0    # How fast the dash moves
@export var dash_duration = 0.2 # How long the dash lasts in seconds
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
@export var hurt_duration = 0.4
var hurt_timer = 0.0

###SIGNALS###
signal player_died
signal health_changed(new_health)
#dash UI signals
signal dash_used(cooldown_duration)
signal dash_cooldown_progress(percent)

#this is the visual skin of the Player
@onready var aiden_model: Node3D = $AidenModel
@onready var brenna_model: Node3D = $brennaModel
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var hurt_collision_shape_3d: CollisionShape3D = $hurtBox/hurtCollisionShape3D
@onready var rock_hurt_sound: AudioStreamPlayer = $Rock_hurt_sound
@onready var death_sound: AudioStreamPlayer = $death_sound
@onready var dash_sound: AudioStreamPlayer = $dash_sound
@onready var gasp_sound: AudioStreamPlayer = $gasp_sound
@onready var footsteps_sound: AudioStreamPlayer = $footsteps_sound


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
	var win_area = get_node("../bridgidSprite/WinArea3D") # Adjust the path as needed
	win_area.player_won.connect(_on_player_won)

	#set the duration of the blend time when going from the idle animation to walking animation
	#animation_player.set_blend_time("idle", "run", 0.2)
	#animation_player.set_blend_time("run","idle", 0.2)

func handle_dashing(delta, direction):
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
		# Calculate and emit progress percentage (0-100)
		var progress = (1.0 - (dash_cooldown_timer / dash_cooldown_duration)) * 100
		emit_signal("dash_cooldown_progress", progress)
	elif dash_cooldown_timer <= 0 and Input.is_action_just_pressed("dash"):
		# This else branch ensures we emit 100% when cooldown is complete
		emit_signal("dash_cooldown_progress", 100)
		dash_sound.play()
		
	#if the dash was just input this frame and dash ability is cooled down to 0
	#if the dash was just input this frame and dash ability is cooled down to 0
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		dashing = true
		dash_cooldown_timer = dash_cooldown_duration
		# Emit signal that dash was used with the cooldown duration
		emit_signal("dash_used", dash_cooldown_duration)
		dash_timer = dash_duration + dash_delay
		dash_direction = last_input_direction
	
	# Update dash timer if in the middle of a dash
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false

func take_damage(damage: int) -> void:
	running = false
	dashing = false
	hurt = true
	collision_shape_3d.disabled = true
	
	rock_hurt_sound.play()
	gasp_sound.play()
	
	health -= 1
	health_changed.emit(health)

	hurt_timer = hurt_duration
	
	if health <= 0:
		die()
		

func die() -> void:
	running = false
	dashing = false
	hurt = false
	dead = true
	collision_shape_3d.disabled = true
	hurt_collision_shape_3d.disabled = true
	death_sound.play()
	
	
	player_died.emit()

func _on_player_won():
	# Disable colliders so you don't lose during win screen
	collision_shape_3d.disabled = true
	hurt_collision_shape_3d.disabled = true
	won = true
	running = false
	dashing = false
	hurt = false
	
	#get_tree().change_scene_to_file("uid://dcdaghr2y3dg5")
	


	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if dead or won:
		return
		
	if hurt:
		hurt_timer -= delta
		if hurt_timer <= 0:
			hurt = false
			collision_shape_3d.disabled = false
		# Skip all other input processing while hurt
		velocity = Vector3.ZERO  # Optional: stop movement immediately when hurt
		move_and_slide()
		return

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
				footsteps_sound.play()
				#animation_player.play("run")
				
		else:
			velocity.x = 0
			velocity.z = 0
			#if no direction detected but the state is running then the player just stopped moving so we update the state
			if running:
				running = false
				footsteps_sound.stop()
				#animation_player.play("idle")

	move_and_slide()



	
	
	
