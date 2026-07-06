extends Node3D

@export var orbit_speed: float = 0.005
@export var pitch_limit_min: float = -90.0
@export var pitch_limit_max: float = 90.0

@export var zoom_speed: float = 0.025
@export var zoom_min: float = 0.75
@export var zoom_max: float = 15.0
@export var zoom_smoothness: float = 8.0

@onready var camera: Camera3D = $Camera3D

var is_orbiting: bool = false
var target_zoom: float = 5.0

func _ready() -> void:
	target_zoom = camera.position.z

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_orbiting = event.pressed
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_orbiting else Input.MOUSE_MODE_VISIBLE

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom - zoom_speed, zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom + zoom_speed, zoom_min, zoom_max)

	if event is InputEventMouseMotion and is_orbiting:
		rotate_y(-event.relative.x * orbit_speed)

		var new_pitch: float = rotation_degrees.x - event.relative.y * orbit_speed * 57.2958
		rotation_degrees.x = clamp(new_pitch, pitch_limit_min, pitch_limit_max)

func _process(delta: float) -> void:
	camera.position.z = lerp(camera.position.z, target_zoom, zoom_smoothness * delta)
