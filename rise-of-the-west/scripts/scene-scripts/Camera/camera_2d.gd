class_name MapCamera
extends Camera2D

@export var speed: float = 600.0
@export var fastspeed: float = 1200.0

@onready var TopLeftMark = $"../TopLeftMark"
@onready var BottomRightMark = $"../BottomRightMark"

var fast: bool = false
var input_vector: Vector2 = Vector2.ZERO

# Shake variables
var shake_time_left: float = 0.0
var shake_duration: float = 0.0
var shake_magnitude: float = 0.0
var shake_fade: bool = true
var shake_frequency: float = 40.0
var shake_timer: float = 0.0
var shake_offset: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	fast = Input.is_key_pressed(KEY_SHIFT)
	input_vector = Input.get_vector(
		"camera_left",
		"camera_right",
		"camera_up",
		"camera_down"
	)
	
	update_shake(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if zoom.x < 2.2:
				zoom += Vector2(0.06, 0.06)
				
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if zoom.x > 0.5:
				zoom -= Vector2(0.06, 0.06)


func _physics_process(delta: float) -> void:
	var top_left: Vector2 = TopLeftMark.coordinates
	var bottom_right: Vector2 = BottomRightMark.coordinates
	
	var current_speed: float
	
	if fast:
		current_speed = fastspeed
	else:
		current_speed = speed
	
	var potential: Vector2 = global_position + input_vector * current_speed * delta
	
	if potential.x < top_left.x or potential.x > bottom_right.x:
		potential.x = global_position.x
	
	if potential.y < top_left.y or potential.y > bottom_right.y:
		potential.y = global_position.y
	
	global_position = potential


func shake(
	magnitude: float = 12.0,
	duration: float = 0.25,
	frequency: float = 40.0,
	fade: bool = true
) -> void:
	shake_magnitude = magnitude
	shake_duration = duration
	shake_time_left = duration
	shake_frequency = frequency
	shake_fade = fade
	shake_timer = 0.0


func update_shake(delta: float) -> void:
	if shake_time_left <= 0.0:
		offset = Vector2.ZERO
		return
		
	shake_time_left -= delta
	shake_timer -= delta

	if shake_timer <= 0.0:
		shake_timer = 1.0 / shake_frequency
		
		var current_magnitude := shake_magnitude
		
		if shake_fade:
			var shake_percent := shake_time_left / shake_duration
			current_magnitude *= shake_percent
			
		shake_offset = Vector2(
			randf_range(-current_magnitude, current_magnitude),
			randf_range(-current_magnitude, current_magnitude)
		)
		
	offset = shake_offset
