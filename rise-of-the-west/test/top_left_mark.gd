extends Node2D

@export var coordinates: Vector2

func _ready() -> void:
	# Example: Move this node to the exported coordinates
	coordinates = position
