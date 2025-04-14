extends OmniLight3D

var _target_intensity:float

func _ready():
	_target_intensity = randf_range(3, 4)	
	
func _process(delta):
	# lerp the light energy towards the desired light energy over time.
	light_energy = move_toward(light_energy, _target_intensity, 7.0 * delta)
	
	# if we're at the desired light energy, randomly select a new one to get a flickering effect
	if is_equal_approx(light_energy, _target_intensity):
		_target_intensity = randf_range(3, 4) 
