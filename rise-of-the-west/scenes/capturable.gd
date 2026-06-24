class_name capturable
extends NinePatchRect

@export var value: int = 100
@export var faction: String = "neutral"

@export var units_in_box: Array[Unit] = []


var _light = load("res://assets/CapturableAssets/lightbox.png")
var _dark = load("res://assets/CapturableAssets/darkbox.png")
var _neutral = load("res://assets/CapturableAssets/neutralbox.png")

signal faction_change(faction: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	$ProgressBar.value = value
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	if value < 200:
		var unit_count: int = units_in_box.size()
		var potential = value + unit_count * 3
		if potential < 200.0:
			if unit_count > 0:
				print(value)
			value = potential
		else:
			value = 200.0
			faction = "player"
			faction_change.emit(faction)
			self.texture = _light
			$Timer.stop()
		# Optional: Cast to int for printing if you don't want decimals in your logs
		$ProgressBar.value = value
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Unit and visible:
		units_in_box.erase(area)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Unit and visible:
		units_in_box.append(area)
