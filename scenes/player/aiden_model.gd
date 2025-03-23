extends Node3D

#@onready var animation_tree: AnimationTree = 

@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:

	$AnimationTree.set("parameters/state_anim/transition_request", "idle")
	
	

func _physics_process(delta: float) -> void:
	
	if get_parent().get_parent().running:
		$AnimationTree.set("parameters/state_anim/transition_request", "running")
	else:
		$AnimationTree.set("parameters/state_anim/transition_request", "idle")
