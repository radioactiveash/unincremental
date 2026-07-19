extends PanelHighlight

const InputResponse = preload("res://prefabs/input_response.tscn")

@onready var history_rows = $VBoxContainer/GameInfo/ScrollContainer/HistoryRows

@onready var scroll = $VBoxContainer/GameInfo/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()

@onready var command_processor = $CommandProcessor


const Response = preload("res://prefabs/response.tscn")
var max_scroll_length := 0

func _ready() -> void:
	super()
	scrollbar.changed.connect(_handle_scrollbar_changed) #signal
	max_scroll_length = scrollbar.max_value
	
	var boot_message = Response.instantiate()
	var boot_ascii = FileAccess.open("res://text/koala.txt", FileAccess.READ)
	boot_message.text = boot_ascii.get_as_text()
	boot_ascii.close()
	add_response(boot_message)
	
	
	# bootup tasks
	# command_processor.process_command("sub tickcount")

func _process(delta: float) -> void:
	super(delta)

func _on_input_text_submitted(new_text: String) -> void:
	if(new_text.is_empty()): return
	var input_response = InputResponse.instantiate()
	var response = command_processor.process_command(new_text)
	input_response.set_text(new_text, response)
	add_response(input_response)


func add_response(response: Control):
	history_rows.add_child(response)


func _handle_scrollbar_changed():
	if(max_scroll_length != scrollbar.max_value):
		max_scroll_length = scrollbar.max_value
		scroll.scroll_vertical = max_scroll_length
		
