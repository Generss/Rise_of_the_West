extends BoxContainer

@export var MASTER_BUS_NAME = "Master" 
@export var SFX_BUS_NAME = "SFX"
@export var Music_Bus_Name = "Music"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_master_volume_value_changed(value: float) -> void:
	var linear_value = clamp(value, 0.0, 1.0) 
	var bus_index = AudioServer.get_bus_index(MASTER_BUS_NAME)
	var db_value = linear_to_db(value)

	AudioServer.set_bus_volume_db(bus_index, db_value)

	if linear_value == 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)


func _on_sfx_volume_value_changed(value: float) -> void:
	var linear_value = clamp(value, 0.0, 1.0) 
	var bus_index = AudioServer.get_bus_index(SFX_BUS_NAME)
	var db_value = linear_to_db(value)

	AudioServer.set_bus_volume_db(bus_index, db_value)

	if linear_value == 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)


func _on_music_volume_value_changed(value: float) -> void:
	var linear_value = clamp(value, 0.0, 1.0) 
	var bus_index = AudioServer.get_bus_index(Music_Bus_Name)
	var db_value = linear_to_db(value)

	AudioServer.set_bus_volume_db(bus_index, db_value)

	if linear_value == 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
