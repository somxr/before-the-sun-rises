extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Find your player node and connect to its signal
	var player = get_node("../Player")
	player.player_died.connect(_on_player_died)
	
func _on_player_died():
	# Show game over screen
	visible = true
	animation_player.play("fadeIn")
