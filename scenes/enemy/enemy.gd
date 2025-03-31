extends Node3D

const rock_scene := preload("res://scenes/enemy/rock.tscn")
@onready var shoot_position: Node3D = $shootPosition

var player_pos

#TESTIN VARIABLES
@export var testing_mode = true
@export var throw_interval = 2.0  # Seconds between throws
var throw_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_group=get_tree().get_nodes_in_group("player")
	if player_group.size()>0:
		player_pos=player_group[0].global_transform.origin
		look_at(player_pos,Vector3.UP)
		
	if testing_mode:
		throw_timer += delta
		if throw_timer >= throw_interval:
			throw_timer = 0  # Reset timer
			throw(rock_scene)   # Call attack function
	

func throw(rock: PackedScene) -> void:
	var rock_instance := rock.instantiate()
	get_parent().add_child(rock_instance)
	rock_instance.position	= shoot_position.global_position
	rock_instance.direction = global_position.direction_to(player_pos)
	add_child(rock_instance)
	
