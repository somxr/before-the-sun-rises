extends Area3D # or Area3D

signal player_won

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# First emit the signal
		player_won.emit()
		
		# Then change to win screen after a short delay (optional)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://path_to_your_scene/win_screen.tscn")
