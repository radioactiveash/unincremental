class_name ConsumerInfo
extends Control

@export var on: bool = false
@export var powered: bool = false
@export var power_consumption: float = 2

func _on_check_box_toggled(toggled_on: bool) -> void:
	on = toggled_on
