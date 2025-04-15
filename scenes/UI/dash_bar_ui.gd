extends TextureProgressBar

func _ready():
	# Find the player node and connect to its signals
	var player = get_tree().get_nodes_in_group("player")[0]
	
	# Connect to the dash signals
	player.dash_used.connect(_on_dash_used)
	player.dash_cooldown_progress.connect(_on_cooldown_progress)
	
	# Initialize the progress bar to 100% (dash ready)
	value = 100

func _on_dash_used(cooldown_duration):
	# Dash was used, reset progress bar to 0
	value = 0

func _on_cooldown_progress(percent):
	# Update progress bar with current cooldown percentage
	value = percent
