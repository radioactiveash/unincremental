extends Node


func process_command(input: String):
	input.to_lower()
	
	var words = input.split(" ", false)
	
	if words.size() <= 0: return "NO WORDS PARSED.\n"
	
	var arg = ""
	if(words.size() > 1):
		arg = words[1]
	match words[0]:
		"help": 
			var help = FileAccess.open("text/help.txt", FileAccess.READ)
			var help_text = help.get_as_text()
			help.close()
			return help_text
		"sub":
			return sub(arg)
		"unsub":
			return unsub(arg)
	
	return "<ERROR> COMMAND NOT RECOGNISED. Use help for command list. \n"


func sub(arg: String):
	match(arg.to_lower()):
		"tick":
			%tickupdates.add_subscribed_info(Enums.Information.TICK)
		"pos":
			%tickupdates.add_subscribed_info(Enums.Information.POSITION)
	
	return "Added " + arg.to_upper() + " from subscribed information."
func unsub(arg:String):
	match(arg.to_lower()):
		"tick":
			%tickupdates.remove_subscribed_info(Enums.Information.TICK)
		"pos":
			%tickupdates.remove_subscribed_info(Enums.Information.POSITION)
	return "Removed " + arg.to_upper() + " from subscribed information."
