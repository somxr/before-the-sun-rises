class_name HurtBox
extends Area3D



func _on_area_entered(hitbox: Hitbox) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
