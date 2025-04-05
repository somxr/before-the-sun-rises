extends Node3D

@export var speed := 14.0
@export var lifetime := 3.0 
var direction := Vector3.ZERO

@export var gravity_strength := 0
var vertical_velocity := 0.0

@onready var hitbox: Hitbox = $hitbox
@onready var impact_detector: Area3D = $impact_detector
@onready var timer: Timer = $Timer

func _ready():
	timer.wait_time = lifetime
	timer.start()
	#print("Rock created with layers: ", impact_detector.collision_layer)
	#print("Rock looking for masks: ", impact_detector.collision_mask)
	
	# Verify signal connection
	if not impact_detector.is_connected("body_entered", Callable(self, "_on_impact_detector_body_entered")):
		print("WARNING: Signal not connected!")
		impact_detector.connect("body_entered", Callable(self, "_on_impact_detector_body_entered"))

func _physics_process(delta: float) -> void:
	position += direction * speed * delta 
	
	vertical_velocity += gravity_strength * delta
	position.y -= vertical_velocity * delta

func _on_impact_detector_body_entered(body: Node3D) -> void:
	print("Collision detected with: ", body.name)
	print("Body collision layer: ", body.get_collision_layer() if body.has_method("get_collision_layer") else "N/A")
	queue_free()

func _on_timer_timeout() -> void:
	pass
	#queue_free()
