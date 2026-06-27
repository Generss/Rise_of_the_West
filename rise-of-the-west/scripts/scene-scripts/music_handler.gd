extends Node2D

@export var Music_Bus_Name: String = "Music"

var tracks: Dictionary[String, String] = {
	"title": "res://assets/audio/music/title.wav",
	"desert": "res://assets/audio/music/desert_placeholder.wav",
	"battle": "res://assets/audio/music/battle.wav"
}

var music_bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index(Music_Bus_Name)
	if music_bus_index == -1:
		music_bus_index = AudioServer.get_bus_index("Master")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_track(track_name: String) -> void:
	if not tracks.has(track_name):
		print("No track named: ", track_name)
		return

	if $MusicPlayer.stream != null:
		var tween := create_tween()
		tween.tween_property(
			$MusicPlayer,
			"volume_db",
			-80.0,
			2.0
		)

		await tween.finished
		$MusicPlayer.stop()

	var new_stream := load(tracks[track_name]) as AudioStream

	if new_stream == null:
		print("Failed to load track: ", tracks[track_name])
		return
	
	$MusicPlayer.bus = Music_Bus_Name 
	$MusicPlayer.stream = new_stream
	$MusicPlayer.volume_db = 0.0
	$MusicPlayer.play()
