class_name WeaponBlade
extends Weapon

@export var damage: int = 30
@export var push_force: float = 1000
@export var hit_cooldown: float = 0.75

var targets: Array[UnitBody] = []

var hit_cooldowns: Dictionary = {}

var speed: float
var max_speed: float


func _process(delta: float) -> void:
	time_since_fire += delta
	update_hit_cooldowns(delta)
	fire_weapon()


func update_hit_cooldowns(delta: float) -> void:
	var units_to_remove: Array = []

	for unit in hit_cooldowns.keys():
		if not is_instance_valid(unit):
			units_to_remove.append(unit)
			continue

		hit_cooldowns[unit] -= delta

		if hit_cooldowns[unit] <= 0.0:
			units_to_remove.append(unit)

	for unit in units_to_remove:
		hit_cooldowns.erase(unit)


func fire_weapon() -> void:
	var somethingHit: bool = false

	if targets.is_empty():
		return

	for next_target in targets:
		if next_target == null:
			continue

		if not is_instance_valid(next_target):
			continue

		if hit_cooldowns.has(next_target):
			continue

		var spd_ratio: float = 0.0

		if max_speed > 0.0:
			spd_ratio = speed / max_speed

		spd_ratio = clamp(spd_ratio, 0.0, 1.0)

		next_target._on_unit_damge_taken(floor(damage * spd_ratio))

		var dir: Vector2 = global_position.direction_to(next_target.global_position)
		var mag: float = push_force * spd_ratio

		next_target._on_unit_get_pushed(dir, mag)

		hit_cooldowns[next_target] = hit_cooldown

		somethingHit = true

	if somethingHit:
		pass


func update_targets(new_targets: Array[UnitBody], new_spd: float, new_max_spd: float) -> void:
	targets = new_targets.duplicate()
	speed = new_spd
	max_speed = new_max_spd
