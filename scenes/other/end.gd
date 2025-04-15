extends Node2D

@onready var background: ColorRect = $background
@onready var animation_player: AnimationPlayer = $background/AnimationPlayer

const main_menu_scene = preload("uid://w1b4dxwtypo0")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fadeOut")
	background.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("uid://w1b4dxwtypo0")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
