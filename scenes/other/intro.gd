extends Node2D

const main_scene = preload("uid://j3m2akuejogr")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_btn_pressed() -> void:
	MusicPlayer.play_button_sound()
	get_tree().change_scene_to_packed(main_scene)
