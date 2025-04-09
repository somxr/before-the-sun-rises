extends Area3D


signal rock

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# First emit the signal
		rock.emit()
		
