class_name Hitbox
extends Area3D

@export var damage := 10

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func set_disabled(is_disabled: bool) -> void:
	collision_shape_3d.set_deferred("disabled", is_disabled)
	
	
