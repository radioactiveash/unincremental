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
	print("generated_watts: ", generated_watts)
	
	var power_need = _get_needed_power()
	print("power_need: ", power_need)
	
	if generated_watts > power_need:
		print("generated_watts > power_need")
		
		_fully_power_consumers()
		
		var leftover_power = generated_watts - power_need
		
		for battery in _get_charging_batteries():
			if battery.capacity > battery.charge:
				leftover_power = _charge_battery(battery, leftover_power)
	
	
	elif generated_watts == power_need:
		print("generated_watts == power_need")
		_fully_power_consumers()
		
	elif generated_watts < power_need:
		print("generated_watts < power_need")
		
		var extra_power_needed = power_need - generated_watts
		
		if(_get_discharging_batteries().size() > 0):
			for battery in _get_discharging_batteries():
				if extra_power_needed > 0:
					print("extra_power_needed: ", extra_power_needed)
					extra_power_needed = _discharge_battery(battery, extra_power_needed)
					print("battery discharged AND extra_power_needed: ", extra_power_needed)
				else: break
			
			if extra_power_needed > 0:
				#ERROR STATE
				print("ERROR: not enough power WITH battery discharges")
				pass
		else:
			#ERROR STATE
			print("ERROR: not enough power, no batteries discharged")
			pass


func _get_power_generation_from_generators() -> float:
	var watts_this_tick = 0
	for generator in generators:
		if generator.on:
			watts_this_tick += generator.output * generator.efficiency
	return watts_this_tick

func _get_needed_power():
	var needed_power = 0
	for consumer in consumers:
		if consumer.on:
			needed_power += consumer.power_consumption
	return needed_power

func _get_discharging_batteries()-> Array[BatteryInfo]:
	var discharging_batteries: Array[BatteryInfo]
	for battery in batteries:
		if battery.state == Enums.BatteryStates.DISCHARGING:
			discharging_batteries.append(battery)
	return discharging_batteries

func _get_charging_batteries() -> Array[BatteryInfo]:
	var charging_batteries: Array[BatteryInfo]
	for battery in batteries:
		if battery.state == Enums.BatteryStates.CHARGING:
			charging_batteries.append(battery)
	return charging_batteries

func _fully_power_consumers() -> void:
	for consumer in consumers:
		if(consumer.on):
			consumer.powered = true
		
func _partially_power_consumers(power: float) -> void:
	for consumer in consumers:
		if consumer.on and power > 0:
			consumer.powered = true
			power -= consumer.power_consumption
		else:
			consumer.powered = false

func _charge_battery(battery: BatteryInfo, leftover_power: float):
	
	if leftover_power > battery.charge_limit:
		
		battery.charge += battery.charge_limit
		leftover_power -= battery.charge_limit
	else:
		battery.charge += leftover_power
		leftover_power = 0
		
	if battery.charge > battery.capacity:
		leftover_power = battery.charge - battery.capacity
		battery.charge = battery.capacity
		
	return leftover_power
func _discharge_battery(battery: BatteryInfo, extra_power_needed: float) -> float:
	var discharge_amount = min(battery.discharge_limit, battery.capacity, extra_power_needed)
	
	battery.charge -= discharge_amount
	extra_power_needed -= discharge_amount
	return extra_power_needed
