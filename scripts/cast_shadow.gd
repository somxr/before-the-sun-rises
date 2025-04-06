extends Node3D

@onready var shadow_sprite: Sprite3D = $ShadowSprite
@onready var ray_cast_3d: RayCast3D = $RayCast3D

var ray_y_collision_point : float = 0.0 

func _ready() -> void:
	shadow_sprite.visible = false

func _physics_process(delta: float) -> void:
	if ray_cast_3d.is_colliding():
		ray_y_collision_point = ray_cast_3d.get_collision_point().y
		shadow_sprite.global_position.y = ray_y_collision_point + 0.1
		shadow_sprite.visible = true
	else:
		shadow_sprite.visible = false
