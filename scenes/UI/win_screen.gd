extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Find your player node and connect to its signal
	var win_area = get_node("../bridgidSprite/WinArea3D") # Adjust the path as needed
	win_area.player_won.connect(_on_player_won)
	
func _on_player_won():
	# Show win screen
	
	animation_player.play("fadeIn")
	visible = true
