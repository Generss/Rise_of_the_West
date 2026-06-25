class_name Unit
extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var shader_material: ShaderMaterial

var selected := false
var speed: float = 200.0


func _ready() -> void:
	if animated_sprite.material != null:
		animated_sprite.material = animated_sprite.material.duplicate()
		shader_material = animated_sprite.material as ShaderMaterial
	set_outline(0.0)


func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
	var next_position := navigation_agent.get_next_path_position()
	global_position = global_position.move_toward(
		next_position,
		speed * delta
	)


func set_outline(thickness: float) -> void:
	if shader_material == null:
		return
	
	shader_material.set_shader_parameter("outline_width", thickness)
	shader_material.set_shader_parameter("outline_color", Color("#cfab4a"))


func move_to_target(new_target: Vector2) -> void:
	navigation_agent.target_position = new_target


func die() -> void:
	# Death animation goes here
	pass
