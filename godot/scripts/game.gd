extends Node

@onready var timer = $Timer
@onready var game_panel = %gamepanel
var cur_satellite: Satellite

var tickspeed = 0.02 #tickspeed in s #0.01 hardlimit

var tickcount = 0
func _ready() -> void:
	change_tickspeed(tickspeed)

func _on_timer_timeout() -> void:
	tickcount += 1
	
	game_panel.tickupdate()
	
	cur_satellite.tickupdate()

func change_tickspeed(new_tickspeed: float) -> void:
	timer.wait_time = new_tickspeed
