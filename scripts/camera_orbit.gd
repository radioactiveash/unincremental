extends Node3D

## Orbit camera rig. Attach to a Node3D pivot with a Camera3D child.
## RMB drag orbits freely around the pivot on both axes (no limits),
## scroll wheel zooms in/out smoothly, no matter what direction the
## camera starts pointing from (e.g. top-down).

@export var zoom_speed: float = 0.5
@export var zoom_lerp_speed: float = 10.0
@export var min_distance: float = 2.0
@export var max_distance: float = 30.0
@export var mouse_sensitivity: float = 0.01

@onready var camera: Camera3D = $Camera3D

var _dragging: bool = false
var _yaw: float = 0.0
var _pitch: float = 0.0
var _distance: float = 10.0
var _target_distance: float = 10.0
var _cam_dir: Vector3 = Vector3.BACK  # normalized direction from pivot to camera, captured at start

func _ready() -> void:
	# Works regardless of whether the camera starts on -Z, top-down (-Y), etc.
	_distance = camera.position.length()
	if _distance == 0.0:
		_distance = 10.0
	_cam_dir = camera.position.normalized() if camera.position.length() > 0.0 else Vector3.BACK
	_target_distance = _distance

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_dragging = event.pressed
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if _dragging else Input.MOUSE_MODE_VISIBLE
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_target_distance = clamp(_target_distance - zoom_speed, min_distance, max_distance)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_target_distance = clamp(_target_distance + zoom_speed, min_distance, max_distance)

	elif event is InputEventMouseMotion and _dragging:
		_yaw -= event.relative.x * mouse_sensitivity
		_pitch -= event.relative.y * mouse_sensitivity

func _process(delta: float) -> void:
	# Build rotation from yaw/pitch directly via basis instead of setting
	# rotation.x/y separately, so pitch can spin all the way through
	# the poles without flipping or getting stuck.
	var yaw_basis := Basis(Vector3.UP, _yaw)
	var pitch_basis := Basis(Vector3.RIGHT, _pitch)
	basis = yaw_basis * pitch_basis

	_distance = lerp(_distance, _target_distance, delta * zoom_lerp_speed)
	camera.position = _cam_dir * _distance
