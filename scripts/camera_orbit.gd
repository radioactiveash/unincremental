extends Camera3D

@onready var target = $".."
const SENSITIVITY = .01
var is_orbiting = false

@export var zoom_speed: float = 0.025
@export var zoom_min: float = 0
@export var zoom_max: float = 1000
@export var zoom_smoothness: float = 8.0
var target_zoom: float = 0.0

func _ready() -> void:
	target_zoom = position.z

func orbit_transform(origin: Vector3, t: Transform3D, orbit_angle: Vector2) -> Transform3D:
	var dt = Transform3D().rotated(t.basis.x, -orbit_angle.y).rotated(Vector3.UP, -orbit_angle.x)
	t.basis = dt.basis * t.basis;
	t.origin = origin + t.basis.z * (t.origin - origin).length()
	return t

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			is_orbiting = true
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
			is_orbiting = false
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom - zoom_speed, zoom_min, zoom_max)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom + zoom_speed, zoom_min, zoom_max)
	
	
	if is_orbiting and event is InputEventMouseMotion:
		global_transform = orbit_transform(target.global_position, global_transform, event.relative*SENSITIVITY)
	
func _process(delta: float) -> void:
	position.z = lerp(position.z, target_zoom, zoom_smoothness * delta)
