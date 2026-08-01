class_name GeneratorInfo
extends Control

@export var on: bool = false
@export var output: float = 10.0 # Watts
@export var efficiency: float = 0.1 #Percentage, 0 to 1

func get_watts() -> float:
	return output * efficiency

func _on_check_box_toggled(toggled_on: bool) -> void:
	on = toggled_on
