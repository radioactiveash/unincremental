class_name BatteryInfo
extends Control

@export var state = Enums.BatteryStates.CHARGING
@export var capacity: float = 32.0
@export var charge: float = 0.0

@export var charge_limit: float = 1.0
@export var discharge_limit: float = 2.0

@onready var bar = $VBoxContainer/ProgressBar

func _ready() -> void:
	%game.timer.timeout.connect(_on_timer_timeout)
	bar.value = charge
	bar.max_value = capacity
	
func _on_timer_timeout() -> void:
		bar.value = charge 

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		state = Enums.BatteryStates.DISCHARGING
	else:
		state = Enums.BatteryStates.CHARGING
		
func is_chargeable() -> bool:
	return state == Enums.BatteryStates.CHARGING and not is_equal_approx(charge, capacity)
	
func is_dischargeable() -> bool:
	return state == Enums.BatteryStates.DISCHARGING and not is_zero_approx(charge)

func charge_battery(leftover_power: float) -> float:
	var charge_amount: float = min(leftover_power, charge_limit, capacity - charge)
	var old_charge = charge
	charge += charge_amount
	print("Charging: ", self, ". ", old_charge, "/", capacity, " -> ", charge, "/", capacity)
	return leftover_power - charge_amount

func discharge_battery(extra_power_needed: float) -> float:
	var discharge_amount: float = min(discharge_limit, charge, extra_power_needed)
	charge -= discharge_amount
	return extra_power_needed - discharge_amount
