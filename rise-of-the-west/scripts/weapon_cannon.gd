class_name WeaponCannon
extends Weapon

var loaded : bool = true


func _process(delta: float) -> void:
	if not active:
		return

	if target == null or not is_instance_valid(target):
		deactivate()
		return

	time_since_fire += delta

	if time_since_fire >= 1.0 / fire_rate:
		time_since_fire = 0.0
		loaded = true
	
	if loaded:
		fire_weapon()
		loaded = false
