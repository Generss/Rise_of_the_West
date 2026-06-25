class_name UnitBody
extends RigidBody2D

@export var speed: float = 200.0
var steering_strength: float = 6.0
var max_steering_force: float = 1200.0



@export var vision_range: float = 250.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var range_area: Area2D = $RangeArea


func _ready() -> void:
	gravity_scale = 0.0
	lock_rotation = true
	linear_damp = 4.5
	can_sleep = false
	var circle := vision_shape.shape as CircleShape2D
	circle.radius = vision_range


func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	var desired_velocity := direction * speed
	var velocity_difference := desired_velocity - linear_velocity

	var steering_force := velocity_difference * steering_strength

	if steering_force.length() > max_steering_force:
		steering_force = steering_force.normalized() * max_steering_force
	


	apply_central_force(steering_force)
	
	# to handle the sprite facing the right direction
	if(linear_velocity.x > 0):
		$Unit.scale.x = abs(scale.x)
	else:
		$Unit.scale.x = -abs(scale.x)


func die() -> void:
	queue_free()


func _on_unit_movement_initiated(new_target: Vector2) -> void:
	sleeping = false
	navigation_agent.target_position = new_target


func _on_check_enemies_timer_timeout() -> void:
	var in_range: Array[Area2D] = range_area.get_overlapping_areas()
	# so we don't have to create a raycast node
	var space_state := get_world_2d().direct_space_state
	for area in in_range:
		if area is Enemy:
			var enemy: Enemy = area as Enemy
			var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create( global_position, enemy.global_position)
			query.exclude = [self]
			query.collision_mask = 2
			var res := space_state.intersect_ray(query)
			
			if res.is_empty():
				print("LINE OF SIGHT")
			
			
			
