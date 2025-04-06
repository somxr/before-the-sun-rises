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
	elif get_parent().hurt:
		$AnimationTree.set("parameters/state_anim/transition_request", "hurt")
	elif get_parent().dead:
		$AnimationTree.set("parameters/state_anim/transition_request", "die")
	else:
		$AnimationTree.set("parameters/state_anim/transition_request", "idle")

	
