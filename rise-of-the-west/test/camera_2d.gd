extends Camera2D

# Adjust this speed to move the camera faster or slower
@export var speed: float = 600.0
var input_vector: Vector2


func _process(delta: float) -> void:
	input_vector = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")

func _physics_process(delta: float) -> void:
	# Move the camera based on input and delta time
	global_position += input_vector * speed * delta
