class_name GeneratorInfo
extends Control

@export var on = false
@export var output = 10 # Watts
@export var efficiency = 0.1 #Percentage, 0 to 1


func _on_check_box_toggled(toggled_on: bool) -> void:
	on = toggled_on
