extends Node2D

const main_menu_scene = preload("uid://w1b4dxwtypo0")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_goback_btn_pressed() -> void:
	#get_tree().change_scene_to_packed(main_menu_scene)
	get_tree().change_scene_to_file("uid://w1b4dxwtypo0")
