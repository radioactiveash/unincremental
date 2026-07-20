class_name PanelHighlight
extends PanelContainer

var selected = false
@onready var stylebox: StyleBoxFlat = load("res://styles/black.tres")
var this_stylebox: StyleBoxFlat
var target_color = Color.DARK_GRAY /2

@onready var label: Label = $Label

func _ready():
	this_stylebox = stylebox.duplicate()
	this_stylebox.border_color = target_color
	add_theme_stylebox_override("panel", this_stylebox)
	
	

func _process(delta: float) -> void:
	target_color = Color.DARK_GRAY /2
	if(get_global_rect().has_point(get_global_mouse_position())):
		target_color = Color.WHITE
		
	var color = lerp(this_stylebox.border_color, target_color, 10 *delta)
	this_stylebox.border_color = color
	label.label_settings.font_color = color
	
