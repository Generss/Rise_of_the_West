class_name WeaponDynamite
extends Weapon


func fire_weapon() -> void:
	var projectile := projectile_scene.instantiate() as Projectile

	get_tree().current_scene.add_child(projectile)

	projectile.global_position = global_position
	projectile.set_faction(faction)

	var direction := global_position.direction_to(target.global_position)
	projectile.activate_projectile(target.global_position)
	
