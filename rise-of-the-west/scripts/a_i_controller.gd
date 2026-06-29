extends Node2D

@onready var capture_controller : CapturableController = %CapturableController

var time: float = 0

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > 5:
		print(str(time))
		time = 0
	else:
		return
	var my_capturables: Array[capturable] = capture_controller.enemy_capturables.duplicate()
	if my_capturables.is_empty():
		return
	for capture in my_capturables:
		capture.enemy_recruitment()
