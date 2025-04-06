extends Node3D

#@onready var animation_tree: AnimationTree = 

@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:

	$AnimationTree.set("parameters/state_anim/transition_request", "idle")
	
	

func _physics_process(delta: float) -> void:
	
	if get_parent().running and not get_parent().dashing:
		$AnimationTree.set("parameters/state_anim/transition_request", "running")
	elif get_parent().dashing:
		$AnimationTree.set("parameters/state_anim/transition_request", "dashing")
	else:
		$AnimationTree.set("parameters/state_anim/transition_request", "idle")

	
