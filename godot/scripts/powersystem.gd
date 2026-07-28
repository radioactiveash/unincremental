class_name PowerSystem
extends Node
@onready var generators: Array[GeneratorInfo] = $generators.generators
@onready var consumers: Array[ConsumerInfo] = $consumers.consumers
@onready var batteries: Array[BatteryInfo] = $batteries.batteries


func update_power() -> void:
	
	print(generators)
	print(consumers)
	print(batteries)
	
	var generated_watts = _update_generators()
	var remaining_watts = _update_consumers(generated_watts)


func _update_generators() -> float:
	var watts_this_tick = 0.0
	for generator in generators:
		watts_this_tick += generator.output * generator.efficiency
	return watts_this_tick


func _update_consumers(generated_watts: float) -> float:
	var power_after_usage = generated_watts
	for consumer in consumers:
		power_after_usage -= consumer.power_consumption
	return power_after_usage
