class_name ProjectileDynamite
extends Projectile

var destination: Vector2
var start_position: Vector2
var detonation_start: bool = false

@export var max_arc_scale: float = 1.6
@export var stop_distance: float = 8.0
@export var detonation_delay: float = 3.0

var has_exploded: bool = false

@onready var innerBlastZone : Area2D = $InnerBlastZone
@onready var outterBlastZone: Area2D = $OutterBlastZone
@onready var tickingAudio: AudioStreamPlayer2D = $TickingAudio
@onready var explosionAudio: AudioStreamPlayer2D = $ExplosionAudio

var camera : MapCamera 

func _ready() -> void:
	if camera == null:
		camera = get_tree().root.find_child("Camera2D",true,false) as MapCamera

func _process(delta: float) -> void:
	if detonation_start:
		return

	calculate_motion(delta)
	update_arc_scale()

	sprite.rotation = direction.angle()


func _on_area_entered(_area: Area2D) -> void:
	pass


func activate_projectile(new_destination: Vector2) -> void:
	start_position = global_position
	destination = new_destination

	direction = global_position.direction_to(destination)
	desired_velocity = direction * speed

	detonation_start = false
	has_exploded = false
	scale = Vector2.ONE


func calculate_motion(delta: float) -> void:
	global_position += desired_velocity * delta

	if global_position.distance_to(destination) <= stop_distance:
		global_position = destination
		desired_velocity = Vector2.ZERO
		scale = Vector2.ONE
		start_detonation()


func update_arc_scale() -> void:
	var total_distance := start_position.distance_to(destination)

	if total_distance <= 0.0:
		scale = Vector2.ONE
		return

	var traveled_distance := start_position.distance_to(global_position)
	var progress := traveled_distance / total_distance
	progress = clamp(progress, 0.0, 1.0)

	var arc_amount: float = sin(progress * PI)
	var current_scale: float = lerp(1.0, max_arc_scale, arc_amount)

	scale = Vector2(current_scale, current_scale)


func start_detonation() -> void:
	if detonation_start:
		return

	detonation_start = true

	if tickingAudio != null:
		tickingAudio.play()

	await get_tree().create_timer(detonation_delay).timeout

	explode()


func explode() -> void:
	if has_exploded:
		return

	has_exploded = true

	if tickingAudio != null:
		tickingAudio.stop()

	if explosionAudio != null:
		if camera == null:
			return
		camera.shake()
		explosionAudio.play()
		

	damage_units_in_blast() 

	if sprite != null:
		sprite.visible = false

	if explosionAudio != null:
		await explosionAudio.finished

	queue_free()


func damage_units_in_blast() -> void:
	var inner_bodies: Array[Node2D] = innerBlastZone.get_overlapping_bodies()
	var outer_bodies: Array[Node2D] = outterBlastZone.get_overlapping_bodies()

	var already_damaged: Array[UnitBody] = []

	for body in inner_bodies:
		if body is not UnitBody:
			continue

		var unit := body as UnitBody

		if not is_instance_valid(unit):
			continue

		if unit.faction == faction:
			continue

		apply_blast_to_unit(unit, damage, pushing_power)
		already_damaged.append(unit)

	for body in outer_bodies:
		if body is not UnitBody:
			continue

		var unit := body as UnitBody

		if not is_instance_valid(unit):
			continue

		if unit.faction == faction:
			continue

		if already_damaged.has(unit):
			continue

		apply_blast_to_unit(unit, floor(damage * 0.5), pushing_power * 0.5)


func apply_blast_to_unit(unit: UnitBody, blast_damage: int, blast_push: float) -> void:
	var push_direction := global_position.direction_to(unit.global_position)

	if push_direction == Vector2.ZERO:
		push_direction = Vector2.RIGHT

	unit._on_unit_damge_taken(blast_damage)
	unit._on_unit_get_pushed(push_direction, blast_push)
