extends Node3D
var orbit_speed = 0.1 #DOES FULL ORBIT IN 64 SECONDS
func _on_timer_timeout() -> void:
	rotate(Vector3(0, 0, 1), orbit_speed * %Game.tickspeed)
	#\/ counters oribit circle rotation, which looks bad at low torus divisions
	$CSGTorus3D.rotate(Vector3(0, 0, -1), orbit_speed * %Game.tickspeed)
  
