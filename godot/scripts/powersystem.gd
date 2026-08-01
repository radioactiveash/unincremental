class_name PowerSystem
extends Node
@onready var generators: Array[GeneratorInfo] = get_generators()
@onready var consumers: Array[ConsumerInfo] = get_consumers()
@onready var batteries: Array[BatteryInfo] = get_batteries()

func get_generators() -> Array[GeneratorInfo]:
	var result: Array[GeneratorInfo] = []
	for child in %generatorinfo.get_children():
		if child is GeneratorInfo:
			result.append(child)
	return result
	
func get_consumers() -> Array[ConsumerInfo]:
	var result: Array[ConsumerInfo] = []
	for child in %consumerinfo.get_children():
		if child is ConsumerInfo:
			result.append(child)
	return result
	
func get_batteries() -> Array[BatteryInfo]:
	var result: Array[BatteryInfo] = []
	for child in %batteryinfo.get_children():
		if child is BatteryInfo:
			result.append(child)
	return result

#func _ready() -> void:
#	%game.timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta: float) -> void:
	
	var generated_watts = _get_power_generation_from_generators()
	var power_need = _get_needed_power()

	if generated_watts > power_need:
		print("Has excess: ", generated_watts, "/", power_need)
		_fully_power_consumers()
		var leftover_power: float = generated_watts - power_need
		var charging_batteries = _get_charging_batteries()
		if charging_batteries.size() > 0:
			print("Chargable batteries: ", charging_batteries.size())
			for battery in charging_batteries:
				if is_zero_approx(leftover_power): break
				if not is_equal_approx(battery.charge, battery.capacity):
					leftover_power = battery.charge_battery(leftover_power)
		else:
			print("NO chargable batteries")
		if leftover_power > 0.0:
			print("Wasting: ", leftover_power)
	
	elif is_equal_approx(generated_watts, power_need):
		print("Exactly enough: ", generated_watts, "/", power_need)
		_fully_power_consumers()
		
	elif generated_watts < power_need:
		print("NOT enough power: ", generated_watts, "/", power_need)
		var extra_power_needed: float = power_need - generated_watts
		var discharging_batteries: Array[BatteryInfo] = _get_discharging_batteries() 
		if(discharging_batteries.size() > 0):
			for battery in discharging_batteries:
				if extra_power_needed > 0.0:
					print("NEEDS: ", extra_power_needed)
					extra_power_needed = battery.discharge_battery(extra_power_needed)
					print("NEED REMAINING: ", extra_power_needed)
			
			if extra_power_needed > 0.0:
				#ERROR STATE
				#print("ERROR: not enough power WITH battery discharges")
				pass
		else:
			#ERROR STATE
			#print("ERROR: not enough power, no batteries discharged")
			pass

func _get_power_generation_from_generators() -> float:
	var watts_this_tick: float = 0.0
	for generator in generators:
		if generator.on:
			watts_this_tick += generator.get_watts()
	return watts_this_tick

func _get_needed_power():
	var needed_power: float = 0.0
	for consumer in consumers:
		if consumer.on:
			needed_power += consumer.power_consumption
	return needed_power

func _get_discharging_batteries()-> Array[BatteryInfo]:
	var discharging_batteries: Array[BatteryInfo]
	for battery in batteries:
		if battery.is_dischargeable():
			discharging_batteries.append(battery)
	return discharging_batteries

func _get_charging_batteries() -> Array[BatteryInfo]:
	var charging_batteries: Array[BatteryInfo]
	for battery in batteries:
		if battery.is_chargeable():
			charging_batteries.append(battery)
	return charging_batteries

func _fully_power_consumers() -> void:
	for consumer in consumers:
		if consumer.on:
			consumer.powered = true
		
func _partially_power_consumers(power: float) -> void:
	for consumer in consumers:
		if consumer.on and power > 0:
			consumer.powered = true
			power -= consumer.power_consumption
		else:
			consumer.powered = false
