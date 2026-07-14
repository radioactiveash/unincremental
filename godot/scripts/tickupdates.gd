extends RichTextLabel


var subscribed_info = []

func _ready() -> void:
	subscribed_info.resize(Enums.Information.size())
	subscribed_info.fill(false)


func add_subscribed_info(info: Enums.Information):
	subscribed_info[info] = true


func remove_subscribed_info(info: Enums.Information):
	subscribed_info[info] = false


func _on_timer_timeout() -> void:
	var output = "........ TICK UPDATES ........"
	for i in subscribed_info.size():
		if(subscribed_info[i] == true):
			match(i):
				Enums.Information.TICK:
					output += ("\n\n--- TICK ---")
					output += ("\nElapsed Time (s): " + str(%game.tickcount * %game.tickspeed))
					output += ("\nTickspeed (s): " + str(%game.tickspeed))
					output += ("\nTotal Ticks: " + str(%game.tickcount))
				Enums.Information.POSITION:
					output += "\n\n--- POSITION ---"
					output += "\n Number 1: " + str(Vector3.ZERO)
			
	%tickupdates.text = output
