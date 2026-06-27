class_name UnitBody
extends RigidBody2D

@export var speed: float = 200.0
var steering_strength: float = 6.0
var max_steering_force: float = 1200.0

@export var weapon_scene: PackedScene

var weapon : Weapon

@export var vision_range: float = 500.0
@export var faction: String = "Ally"
@export var max_health: int = 100
@export var fire_rate: float = 2    # per second
@export var move_and_shoot: bool = true

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var range_area: Area2D = $RangeArea

@onready var current_health = max_health

var fire_load_time : float = 0 # the time since last fire


var combat_target : UnitBody = null
var UnitNode : Unit

func _ready() -> void:
	weapon = weapon_scene.instantiate()
	add_child(weapon)
	weapon.faction = faction
	
	gravity_scale = 0.0
	lock_rotation = true
	linear_damp = 6
	can_sleep = false
	var circle := vision_shape.shape as CircleShape2D
	circle.radius = vision_range
	UnitNode = get_node("Unit")
	UnitNode.faction = faction


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
	
	if !is_instance_valid(UnitNode):
		return
	
	# to handle the sprite facing the right direction
	if(linear_velocity.x > 0):
		UnitNode.scale.x = abs(scale.x)
	else:
		UnitNode.scale.x = -abs(scale.x)


func die() -> void:
	set_physics_process(false)
	call_deferred("queue_free")


func _on_unit_movement_initiated(new_target: Vector2) -> void:
	sleeping = false
	navigation_agent.target_position = new_target


func _on_check_enemies_timer_timeout() -> void:
	if combat_target != null:
		if not is_instance_valid(combat_target):
			combat_target = null
			weapon.deactivate()
		elif combat_target.global_position.distance_to(global_position) > vision_range:
			combat_target = null
			weapon.deactivate()
		else:
			return
			
	var in_range: Array[Node2D] = range_area.get_overlapping_bodies()
	# so we don't have to create a raycast node
	var space_state := get_world_2d().direct_space_state
	var units_in_range: Array[UnitBody] 
	for body in in_range:
		if body is UnitBody:
			var enemy : UnitBody = body as UnitBody
			if enemy.faction != faction:
				var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create( global_position, enemy.global_position)
				query.exclude = [self]
				query.collision_mask = 2
				var res := space_state.intersect_ray(query)
				if res.is_empty():
					#print("As " + faction + " LINE OF SIGHT on: " + enemy.faction )
					units_in_range.append(enemy)
	if units_in_range.is_empty():
		combat_target = null
		weapon.deactivate()
		return

	units_in_range.shuffle()
	combat_target = units_in_range[0]
	weapon.activate(combat_target)




func _on_unit_damge_taken(damage: int) -> void:
	if(damage >= current_health):
		die()
	else:
		current_health -= damage 


func _on_unit_get_pushed(direction: Vector2, magnitude: float) -> void:
	if direction == Vector2.ZERO:
		return
	sleeping = false
	var impulse := direction.normalized() * magnitude
	apply_central_impulse(impulse)
	
