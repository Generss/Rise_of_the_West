class_name UnitCavalry
extends UnitBody


@export var acceleration: float = 300.0
@export var deceleration: float = 450.0
@export var turn_slowdown_strength: float = 0.9
@export var minimum_turn_speed_percent: float = 0.45

var previous_move_direction: Vector2 = Vector2.ZERO

var blade : WeaponBlade
var current_move_speed: float = 0.0


func _ready() -> void:
	
	weapon = weapon_scene.instantiate()
	add_child(weapon)
	weapon.faction = faction
	unit.faction = faction
	
	blade = weapon as WeaponBlade
	
	gravity_scale = 0.0
	lock_rotation = true
	linear_damp = 0.5
	#can_sleep = false
	var circle := vision_shape.shape as CircleShape2D
	circle.radius = vision_range
	UnitNode = get_node("Unit")
	UnitNode.apply_faction(faction)


func _physics_process(delta: float) -> void:
	frame_counter += 1
	
	var is_moving := not navigation_agent.is_navigation_finished()
	
	if is_moving and not move_and_shoot:
		weapon.deactivate()
		
	if is_moving:
		current_move_speed = move_toward(
			current_move_speed,
			speed,
			acceleration * delta
		)
	else:
		current_move_speed = move_toward(
			current_move_speed,
			0.0,
			deceleration * delta
		)
		
		previous_move_direction = Vector2.ZERO
		
		var desired_velocity := Vector2.ZERO
		var velocity_difference := desired_velocity - linear_velocity
		var braking_force := velocity_difference * steering_strength
		
		if braking_force.length() > max_steering_force:
			braking_force = braking_force.normalized() * max_steering_force
		
		apply_central_force(braking_force)
		return
	
	next_position = navigation_agent.get_next_path_position()
	direction = global_position.direction_to(next_position)
	
	var turn_speed_multiplier := 1.0
	
	if previous_move_direction != Vector2.ZERO:
		var direction_similarity := previous_move_direction.dot(direction)
		direction_similarity = clamp(direction_similarity, -1.0, 1.0)
		
		var turn_amount := 1.0 - direction_similarity
		turn_amount *= 0.5
		
		var slowdown_amount := turn_amount * turn_slowdown_strength
		
		turn_speed_multiplier = 1.0 - slowdown_amount
		turn_speed_multiplier = max(turn_speed_multiplier, minimum_turn_speed_percent)
	
	previous_move_direction = direction
	
	var adjusted_move_speed := current_move_speed * turn_speed_multiplier
	
	var desired_velocity := direction * adjusted_move_speed
	var velocity_difference := desired_velocity - linear_velocity
	var steering_force := velocity_difference * steering_strength
	
	if steering_force.length() > max_steering_force:
		steering_force = steering_force.normalized() * max_steering_force
	
	apply_central_force(steering_force)
	
	if !is_instance_valid(UnitNode):
		return
	
	if linear_velocity.x > 0:
		UnitNode.scale.x = abs(scale.x)
	else:
		UnitNode.scale.x = -abs(scale.x)
		
	print("desired: ", current_move_speed, " adjusted: ", adjusted_move_speed, " actual: ", linear_velocity.length())

func _on_check_enemies_timer_timeout() -> void:
	pass

func _on_body_entered(_body: Node) -> void:
	var in_range: Array[Node2D] = get_colliding_bodies()
	# so we don't have to create a raycast node
	var units_in_range: Array[UnitBody] 
	for body in in_range:
		if body is UnitBody:
			var enemy : UnitBody = body as UnitBody
			if enemy.faction != faction:
				if check_sight(enemy.global_position):
					#print("As " + faction + " LINE OF SIGHT on: " + enemy.faction )
					units_in_range.append(enemy)
	if units_in_range.is_empty():
		combat_target = null
		return
	else:
		blade.update_targets(units_in_range,current_move_speed,speed)
		
