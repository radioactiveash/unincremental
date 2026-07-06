extends TextureRect

@onready var sub_viewport: SubViewport = $"../SubViewport"  # adjust path to match your tree
@onready var camera_pivot: Node3D = $"../SubViewport/CameraPivot"

@export var orbit_speed: float = 0.005
@export var pitch_limit_min: float = -80.0
@export var pitch_limit_max: float = 80.0

var is_orbiting: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP  # make sure it's not left at default/ignore

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		is_orbiting = event.pressed

	if event is InputEventMouseMotion and is_orbiting:
		camera_pivot.rotate_y(-event.relative.x * orbit_speed)
		var new_pitch: float = camera_pivot.rotation_degrees.x - event.relative.y * orbit_speed * 57.2958
		camera_pivot.rotation_degrees.x = clamp(new_pitch, pitch_limit_min, pitch_limit_max)
