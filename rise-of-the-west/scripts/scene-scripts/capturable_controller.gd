extends Node2D

var _capturable_count = 0
var _player_capturables = 0
@onready var capturables: Array[capturable] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is capturable:
			if child.has_signal("faction_change"):
				child.faction_change.connect(_on_capturable_faction_change)
			_capturable_count += 1
			capturables.append(child)
	print("Needed points: ", _capturable_count)

func _on_capturable_faction_change(location: capturable, faction: String) -> void:
	%EconomyUI.new_town(location)
	print(faction)
	if faction == "player":
		_player_capturables += 1
	if _player_capturables == _capturable_count:
		print("Win")
