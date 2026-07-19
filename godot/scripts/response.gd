extends RichTextLabel

var full_text = ""
var cur_chars = 0
var timer = 0
var chars_per_second = 256
var timer_paused = false


func _ready() -> void:
	full_text = text
	text = ""
	pass # Replace with function body.


func _process(delta: float) -> void:
	if cur_chars >= full_text.length():
		return

	if !timer_paused:
		timer += delta
		
	var interval: float = 1.0 / chars_per_second

	while timer >= interval and cur_chars < full_text.length():
		timer -= interval
		cur_chars += 1
		text = full_text.substr(0, cur_chars)
