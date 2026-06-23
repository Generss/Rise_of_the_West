extends Camera2D

# Adjust this speed to move the camera faster or slower
@export var speed: float = 600.0
var input_vector: Vector2
@onready var TopLeftMark = $"../TopLeftMark"
@onready var BottomRightMark = $"../BottomRightMark"

func _process(delta: float) -> void:
	input_vector = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")

func _physics_process(delta: float) -> void:
	# Move the camera based on input and delta time
	var TopLeft: Vector2 = TopLeftMark.coordinates
	var BottomRight: Vector2 = BottomRightMark.coordinates
	var potential: Vector2 = global_position + input_vector * speed * delta
	#print(potential.x)
	#print(potential.y)
	if(potential.x < TopLeft.x or potential.x > BottomRight.x):
		potential.x = global_position.x
	if(potential.y < TopLeft.y or potential.y > BottomRight.y):
		potential.y = global_position.y
	global_position = potential
