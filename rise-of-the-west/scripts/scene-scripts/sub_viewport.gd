extends SubViewport

@onready var MainCamera = $"../../../../Camera2D"
@onready var MiniMapCamera = $Camera2D

func _ready() -> void:
	 # "world_2d" refers to this SubViewport's own 2D world.
	 # "get_tree().root" will fetch the game's main viewport.
	world_2d = get_tree().root.world_2d

func _physics_process(delta: float) -> void:
	MiniMapCamera.position = MainCamera.position
