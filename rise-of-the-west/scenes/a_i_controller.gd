extends Node2D

@onready var capture_controller : CapturableController = %CapturableController

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var my_capturables: Array[capturable] = capture_controller.enemy_capturables.duplicate()
	if my_capturables.is_empty():
		return
	for capture in my_capturables:
		capture.enemy_recruitment()
