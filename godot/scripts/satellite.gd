extends Node3D
var orbit_speed = 0.1 #DOES FULL ORBIT IN 64 SECONDS
@onready var power_system = $powersystem
func _on_timer_timeout() -> void:
	
	rotate(Vector3(0, 1, 0), orbit_speed * %game.tickspeed)
	#\/ counters oribit circle rotation, which looks bad at low torus divisions
	$CSGTorus3D.rotate(Vector3(0, -1, 0), orbit_speed * %game.tickspeed)
	
	
	power_system._update_generators()
