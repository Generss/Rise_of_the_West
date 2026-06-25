extends Camera2D

# Adjust this speed to move the camera faster or slower
@export var speed: float = 600.0
@export var fastspeed: float = 1200.0
var fast: bool = false
var input_vector: Vector2
@onready var TopLeftMark = $"../TopLeftMark"
@onready var BottomRightMark = $"../BottomRightMark"

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		fast = true
	else:
		fast = false
	input_vector = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if self.zoom.x < 2.2:
				self.zoom.x += 0.06
				self.zoom.y += 0.06
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if self.zoom.x > 0.5:
				self.zoom.x -= 0.06
				self.zoom.y -= 0.06

func _physics_process(delta: float) -> void:
	# Move the camera based on input and delta time
	var TopLeft: Vector2 = TopLeftMark.coordinates
	var BottomRight: Vector2 = BottomRightMark.coordinates
	var currentspeed
	if fast:
		currentspeed = fastspeed
	else:
		currentspeed = speed
	var potential: Vector2 =  global_position + input_vector * currentspeed * delta
	#print(potential.x)
	#print(potential.y)
	if(potential.x < TopLeft.x or potential.x > BottomRight.x):
		potential.x = global_position.x
	if(potential.y < TopLeft.y or potential.y > BottomRight.y):
		potential.y = global_position.y
	global_position = potential
