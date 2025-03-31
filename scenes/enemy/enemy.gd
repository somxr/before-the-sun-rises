extends Node3D

enum State {IDLE, THROWING}

const rock_scene := preload("res://scenes/enemy/rock.tscn")
@onready var shoot_position: Node3D = $shootPosition
@onready var animation_player: AnimationPlayer = $enemyModel1/AnimationPlayer

var player_pos
var current_state = State.IDLE

##TESTING VARIABLES
@export var testing_mode = true
@export var throw_interval = 2.0  # Seconds between throws
var throw_timer = 0.0

func _ready() -> void:
	# Connect animation finished signal
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	# Start idle animation
	animation_player.play("idle")

func _physics_process(delta: float) -> void:
	var player_group = get_tree().get_nodes_in_group("player")
	if player_group.size() > 0:
		player_pos = player_group[0].global_transform.origin
		look_at(player_pos, Vector3.UP)
		
	if testing_mode and current_state == State.IDLE:
		throw_timer += delta
		if throw_timer >= throw_interval:
			throw_timer = 0
			throw()

func throw() -> void:
	if current_state == State.IDLE:
		current_state = State.THROWING
		animation_player.play("throw")

func spawn_rock_from_animation() -> void:
	var rock_instance := rock_scene.instantiate()
	get_parent().add_child(rock_instance)
	rock_instance.position = shoot_position.global_position
	rock_instance.direction = global_position.direction_to(player_pos)

func _on_animation_finished(anim_name: StringName) -> void:
	#print("Animation finished: ", anim_name)
	if anim_name == "throw" and current_state == State.THROWING:
		current_state = State.IDLE
		animation_player.play("idle")
