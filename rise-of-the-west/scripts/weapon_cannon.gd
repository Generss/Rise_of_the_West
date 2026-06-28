class_name WeaponCannon
extends Weapon

var loaded : bool = true
var camera : MapCamera 

func _ready() -> void:
	if camera == null:
		camera = get_tree().root.find_child("Camera2D",true,false) as MapCamera

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
		if camera == null:
			return
		
		camera.shake()
		fire_weapon()
		loaded = false
