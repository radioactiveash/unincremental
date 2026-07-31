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


func _ready() -> void:
	%game.timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	update_power() ## TODO - seperate from tickspeed
	pass


func update_power() -> void:
	
	print(generators)
	print(consumers)
	print(batteries)
	
	var generated_watts = _get_power_generation_from_generators()
	print("generated_watts: ", generated_watts)
	
	var power_need = _get_needed_power()
	print("power_need: ", power_need)
	
	if generated_watts > power_need:
		print("generated_watts > power_need")
		
		_fully_power_consumers()
		
		pass
	elif generated_watts == power_need:
		print("generated_watts == power_need")
		
		pass
	elif generated_watts < power_need:
		print("generated_watts < power_need")
		
		var extra_power_needed = power_need - generated_watts
		
		if(_get_discharging_batteries().size() == 0):
			pass
		else:
			pass
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
		
func _partially_power_consumers(power: int) -> void:
	for consumer in consumers:
		if consumer.on and power > 0:
			consumer.powered = true
			power -= consumer.power_consumption
		else:
			consumer.powered = false
