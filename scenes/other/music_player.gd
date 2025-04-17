extends Node

# Track types enum
enum Tracks {
	NONE,
	MAIN_THEME,
	ENDING
}

# Current track being played
var _current_track_id: int = Tracks.NONE

# Dictionary to map track IDs to their respective AudioStreamPlayer nodes
@onready var _track_stream_players: Dictionary = {
	Tracks.MAIN_THEME: $MainTheme,
	Tracks.ENDING: $EndingTheme
}

# Sound effect players
@onready var _button_sound: AudioStreamPlayer = $ButtonSound

# Called when the node enters the scene tree
func _ready():
	# Start with all tracks stopped and volume set to minimum
	for track_player in _track_stream_players.values():
		track_player.stop()
		track_player.volume_db = -80.0

# Transitions to a new track with optional fade
func transition_to_track(new_track_id: int, fade_time: float = 1.5, transition_delay: float = 0.0) -> void:
	# Verify the track exists
	assert(
		_track_stream_players.keys().has(new_track_id), 
		"MusicPlayer Error: Tried to transition to non-existent track."
	)
	
	# If the requested track is already playing, do nothing
	if new_track_id == _current_track_id:
		return
	
	# If we're currently playing a track, fade it out
	if _current_track_id != Tracks.NONE:
		_track_fade(_current_track_id, false, fade_time)
		if transition_delay > 0.0:
			await get_tree().create_timer(transition_delay).timeout
	
	# Fade in the new track
	_track_fade(new_track_id, true, fade_time)
	_current_track_id = new_track_id

# Stops all music with optional fade out
func stop_music(fade_time: float = 1.5) -> void:
	if _current_track_id != Tracks.NONE:
		_track_fade(_current_track_id, false, fade_time)
		_current_track_id = Tracks.NONE

# Returns the current track ID
func get_current_track() -> int:
	return _current_track_id
	
# Play the button click sound effect
func play_button_sound(volume_db: float = 0.0) -> void:
	# Store original volume
	var original_volume = _button_sound.volume_db
	
	# Set new volume if different from current
	if volume_db != original_volume:
		_button_sound.volume_db = volume_db
	
	# Play the sound
	_button_sound.play()
	
	# Reset volume to original after playing (if we changed it)
	if volume_db != original_volume:
		# Wait until sound is finished before resetting volume
		await _button_sound.finished
		_button_sound.volume_db = original_volume

# Private method to handle fading tracks in or out
func _track_fade(track_id: int, fade_in: bool, fade_time: float) -> void:
	var track_stream_player: AudioStreamPlayer = _track_stream_players[track_id]
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	if fade_in:
		track_stream_player.play()
		tween.tween_property(
			track_stream_player, "volume_db", 0.0, fade_time
		).from(-80.0).set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(
			track_stream_player, "volume_db", -80.0, fade_time
		).from(0.0).set_ease(Tween.EASE_OUT)
		tween.chain().tween_callback(Callable(track_stream_player, "stop"))
	
	tween.play()
