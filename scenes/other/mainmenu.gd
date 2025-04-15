extends Node2D

const intro_scene = preload("uid://cvwy7kxy7clc6")
#const credits_scene = preload("uid://c50ulsav63jyb")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_packed(intro_scene)


func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("uid://c50ulsav63jyb")
