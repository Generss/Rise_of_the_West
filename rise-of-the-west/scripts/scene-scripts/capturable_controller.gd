class_name CapturableController
extends Node2D

var _capturable_count = 0
var _player_capturables = 0
@onready var capturables: Array[capturable] = []
@onready var ally_capturables: Array[capturable] = []
@onready var enemy_capturables: Array[capturable] = []
@onready var economy_ui: EconomyUI = %EconomyUI


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is capturable:
			if child.has_signal("faction_change"):
				child.faction_change.connect(_on_capturable_faction_change)
			_capturable_count += 1
			capturables.append(child)
	print("Needed points: ", _capturable_count)

# This should only be called WHEN THE FACTION CHANGES
func _on_capturable_faction_change(location: capturable) -> void:
	if location.faction == "Neutral":
		print("Formerly Neutral")
		if location in ally_capturables:
			print("Ally lost location")
			ally_capturables.erase(location)
			%EconomyUI.lose_town(location)
			return
		else:
			print("Enemy lost location")
			enemy_capturables.erase(location)
			economy_ui.lose_ememy_town(location)
			return
	elif location.faction == "Ally":
		print("Ally gained location")
		ally_capturables.append(location)
		%EconomyUI.new_town(location)
	else:
		print("Enemy gained location")
		%EconomyUI.new_enemy_town(location)
		enemy_capturables.append(location)
