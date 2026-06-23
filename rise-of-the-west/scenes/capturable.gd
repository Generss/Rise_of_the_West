extends NinePatchRect

@export var value: int = 0

@export var units_in_box: Array[Unit] = []

var _light = load("res://assets/CapturableAssets/lightbox.png")
var _dark = load("res://assets/CapturableAssets/darkbox.png")
var _neutral = load("res://assets/CapturableAssets/neutralbox.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	if value < 100.0:
		var unit_count: int = units_in_box.size()
		print(unit_count)
		var potential = value + unit_count
		if potential < 100.0:
			print(value)
			value = potential
		else:
			value = 100.0
			print("captured")
			self.texture = _light
			$Timer.stop()
		# Optional: Cast to int for printing if you don't want decimals in your logs
		print(int(value))
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Unit and visible:
		print("unit left capturable zone")
		units_in_box.erase(area)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Unit and visible:
		print("unit entered capturable zone")
		units_in_box.append(area)
