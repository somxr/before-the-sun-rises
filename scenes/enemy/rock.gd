extends Node3D


@export var speed := 12.0
@export var lifetime := 3.0 

var direction := Vector3.ZERO

@onready var hitbox: Hitbox = $hitbox
@onready var impact_detector: Area3D = $impact_detector
@onready var timer: Timer = $Timer


func _read():
	pass
	
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_impact_detector_body_entered(body: Node3D) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
