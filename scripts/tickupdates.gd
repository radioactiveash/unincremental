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
	var output = "TICK UPDATES: \n \n"
	for i in subscribed_info.size():
		if(subscribed_info[i] == true):
			match(i):
				Enums.Information.TICKCOUNT:
					output += ("\nSECONDS ELAPSED: " + str(%game.tickcount * %game.tickspeed))
					output += ("\nTICKSPEED (s): " + str(%game.tickspeed))
					output += ("\nTOTAL TICKS: " + str(%game.tickcount))

				Enums.Information.POSITION:
					output += "\n\nPosition"
			
	%tickupdates.text = output
