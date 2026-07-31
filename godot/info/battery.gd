class_name BatteryInfo
extends Control

@export var state = Enums.BatteryStates.CHARGING
@export var capacity: float = 32
@export var charge: float = 0

@export var charge_limit = 1
@export var discharge_limit = 2

@onready var bar = $VBoxContainer/ProgressBar
func _ready() -> void:
	%game.timer.timeout.connect(_on_timer_timeout)
	bar.max_value = capacity


func _on_timer_timeout() -> void:
		bar.value = charge 


func _on_check_button_toggled(toggled_on: bool) -> void:
	
	if toggled_on:
		state = Enums.BatteryStates.DISCHARGING
	else:
		state = Enums.BatteryStates.CHARGING
