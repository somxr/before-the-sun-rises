extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.stop_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://scenes/other/mainmenu.tscn")
