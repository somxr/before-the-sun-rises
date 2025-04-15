extends Node3D

enum State {IDLE, THROWING}

const rock_scene := preload("res://scenes/enemy/rock.tscn")
@onready var shoot_position: Node3D = $shootPosition
@onready var animation_player2: AnimationPlayer = $friarModel/AnimationPlayer

var player_pos
var current_state = State.IDLE

##TESTING VARIABLES
@export var throwing_mode = true
@export var throw_interval = 2.0  # Seconds between throws
@export var throw_speed = 14.0
@export var rock_gravity = 6.0
@export var throw_range = 30.0  # Maximum distance to throw at player

var throw_timer = 0.0

func _ready() -> void:
	# Connect animation finished signal
	animation_player2.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	# Start idle animation
	animation_player2.play("friar_anim/idle_enemy")

func _physics_process(delta: float) -> void:
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		player_pos = player_group[0].global_transform.origin
		
		# Calculate distance to player
		var distance_to_player = global_position.distance_to(player_pos)
		
		# Always look at player regardless of distance
		look_at(player_pos, Vector3.UP)
		
		# Only throw if player is within range
		if throwing_mode and current_state == State.IDLE and distance_to_player <= throw_range:
			throw_timer += delta
			if throw_timer >= throw_interval:
				throw_timer = 0
				throw()
		elif distance_to_player > throw_range:
			# Reset timer if player moves out of range
			throw_timer = 0

func throw() -> void:
	if current_state == State.IDLE:
		current_state = State.THROWING
		animation_player2.play("friar_anim/throw_enemy")

func spawn_rock_from_animation() -> void:
	var rock_instance := rock_scene.instantiate()
	rock_instance.speed = throw_speed
	rock_instance.gravity_strength = rock_gravity
	get_parent().add_child(rock_instance)
	rock_instance.position = shoot_position.global_position
	rock_instance.direction = global_position.direction_to(player_pos)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "friar_anim/throw_enemy" and current_state == State.THROWING:
		current_state = State.IDLE
		animation_player2.play("friar_anim/idle_enemy")
