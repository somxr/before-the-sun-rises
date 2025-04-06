extends Control

@onready var health_point_1: TextureRect = $healthPoint1
@onready var health_point_2: TextureRect = $healthPoint2
@onready var health_point_3: TextureRect = $healthPoint3


func _ready():
	# Connect to player's health_changed signal
	var player = get_node("../Player")  # Adjust path if needed
	if player:
		player.health_changed.connect(_on_player_health_changed)
		


func _on_player_health_changed(new_health):
	# Update health points visibility based on current health
	match new_health:
		3:
			# Full health - all visible
			health_point_1.visible = true
			health_point_2.visible = true
			health_point_3.visible = true
		2:
			# Two health points
			health_point_1.visible = true
			health_point_2.visible = true
			health_point_3.visible = false
		1:
			# One health point
			health_point_1.visible = true
			health_point_2.visible = false
			health_point_3.visible = false
		0, -1:
			# No health points
			health_point_1.visible = false
			health_point_2.visible = false
			health_point_3.visible = false
