class_name UnitBody
extends RigidBody2D


var steering_strength: float = 6.0
var max_steering_force: float = 1200.0



var weapon : Weapon

enum AI_State {LOOKING,GOING, CAPTURING}
var current_state : AI_State = AI_State.LOOKING

@export var speed: float = 200.0
@export var weapon_scene: PackedScene
@export var vision_range: float = 500.0
@export var faction: String = "Ally"
@export var max_health: int = 100
@export var move_and_shoot: bool = true
@export var economyui : Node
@export var unit_type: String = "RevolverInfantry"

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var range_area: Area2D = $RangeArea
@onready var capturable_controller : CapturableController = null
@onready var current_health = max_health
@onready var unit : Unit = $Unit



var current_capturable : capturable = null
var fire_load_time : float = 0 # the time since last fire
var frame_counter : int = 0 # to count frames for things that we don't want to run every update
var next_position : Vector2
var direction : Vector2

var queued_clean : bool = false

var combat_target : UnitBody = null
var UnitNode : Unit

func _ready() -> void:
	
	
	weapon = weapon_scene.instantiate()
	add_child(weapon)
	weapon.faction = faction
	
	unit.faction = faction
	
	gravity_scale = 0.0
	lock_rotation = true
	linear_damp = 6
	#can_sleep = false
	var circle := vision_shape.shape as CircleShape2D
	circle.radius = vision_range
	UnitNode = get_node("Unit")
	UnitNode.faction = faction


func _process(_delta: float) -> void:
	if faction == "Enemy":
		run_AI()

func _physics_process(_delta: float) -> void:
	frame_counter += 1
	
	var is_moving := not navigation_agent.is_navigation_finished()
	
	if is_moving and not move_and_shoot:
		weapon.deactivate()
	
	if not is_moving:
		return
	
		
	next_position = navigation_agent.get_next_path_position()
	direction = global_position.direction_to(next_position)

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
	if queued_clean:
		return
	queued_clean = true
	if faction == "Ally":
		print("Dead Ally function")
		economyui.lost_unit()
	elif faction == "Enemy":
		print("Dead Enemy function")
		economyui.enemy_lost_unit()
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
		elif not check_sight(combat_target.global_position):
			combat_target = null
			weapon.deactivate()
		else:
			return
			
	var in_range: Array[Node2D] = range_area.get_overlapping_bodies()
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


func _on_unit_get_pushed(new_direction: Vector2, magnitude: float) -> void:
	if new_direction == Vector2.ZERO:
		return
	sleeping = false
	var impulse := new_direction.normalized() * magnitude
	apply_central_impulse(impulse)

func check_sight(los_target: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create( global_position, los_target)
	query.exclude = [self]
	query.collision_mask = 2
	var res := space_state.intersect_ray(query)
	return res.is_empty()

func run_AI() -> void:
	
	if capturable_controller == null:
		capturable_controller = get_tree().root.find_child("CapturableController", true, false) as CapturableController
		
		if capturable_controller == null:
			print("WHOOPS! Could not find CapturableController")
			return

		
	match current_state:
		AI_State.LOOKING:
			#print("looking")
			var possible_capturables: Array[capturable] = capturable_controller.capturables.filter(
				func(capture: capturable):
					return capture.faction == "Ally" or capture.faction == "Neutral"
			)
			
			if possible_capturables.is_empty():
				return
				
			var closest: capturable = null
			var closest_dist := INF
			
			for capture in possible_capturables:
				var dist := global_position.distance_squared_to(capture.global_position)
				
				if dist < closest_dist:
					closest_dist = dist
					closest = capture
					
			current_capturable = closest
			
			if current_capturable == null:
				return
				
			current_state = AI_State.GOING
			_on_unit_movement_initiated(current_capturable.get_global_rect().get_center())
			
		AI_State.GOING:
			#print("GOING")
			if navigation_agent.is_navigation_finished():
				current_state = AI_State.CAPTURING
			
		AI_State.CAPTURING:
			#print("CAPTURING")
			if current_capturable == null or not is_instance_valid(current_capturable):
				current_state = AI_State.LOOKING
				return

			var capture_rect := current_capturable.get_global_rect()

			if not capture_rect.has_point(global_position):
				current_capturable = null
				current_state = AI_State.LOOKING
				return

			if current_capturable.faction == "Enemy":
				current_state = AI_State.LOOKING
	
	
