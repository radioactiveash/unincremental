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

	return "<ERROR> COMMAND NOT RECOGNISED. USE help FOR COMMAND LIST. \n"

func sub(arg: String):
	match(arg.to_lower()):
		"tickcount":
			%tickupdates.add_subscribed_info(Enums.Information.TICKCOUNT)
		"position":
			%tickupdates.add_subscribed_info(Enums.Information.POSITION)
	
	return "ADDED " + arg.to_upper() + " TO SUBSCRIBED INFORMATION"
func unsub(arg:String):
	match(arg.to_lower()):
		"tickcount":
			%tickupdates.remove_subscribed_info(Enums.Information.TICKCOUNT)
		"position":
			%tickupdates.remove_subscribed_info(Enums.Information.POSITION)
	return "REMOVED " + arg.to_upper() + " FROM SUBSCRIBED INFORMATION"
