extends Node




@onready var generators: Array[Generator] = _get_generators()


func _get_generators() -> Array[Generator]:
	var result: Array[Generator] = []
	for child in $generators.get_children():
		if child is Generator:
			result.append(child)
	return result

func _update_generators() -> void:
	pass
