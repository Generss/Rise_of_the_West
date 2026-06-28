class_name ProjectileBall
extends Projectile


var units_hit : Array[Unit] 

func _process(delta: float) -> void:
	calculate_motion(delta)

	


func _on_area_entered(area: Area2D) -> void:
	if area is Unit:
		var unit = area as Unit
		var already_hit : bool = units_hit.find(unit) != -1
		if unit.faction != faction and not already_hit:
			var push_direction : Vector2 = -global_position.direction_to(unit.global_position)
			unit.push_unit(push_direction, pushing_power)
			unit.take_damage(damage)
			units_hit.append(unit)




func _on_already_hit_timeout() -> void:
	if not units_hit.is_empty():
		units_hit.pop_front()
