extends Node


func process_command(input: String):
	input.to_lower()
	
	var words = input.split(" ", false)
	
	if words.size() <= 0: return "NO WORDS PARSED.\n"
	var arg = ""
	if(words.size() > 1):
		arg = words[1]
	match words[0]: #c
		"help": 
			return "COMMAND LIST: \n \n help : OPEN COMMAND LIST \n \n go <location> : MOVES YOU TO SPECIFICED LOCATION \n KNOWN LOCATIONS : home \n"
		"go":
			return go(arg)

	return "<ERROR> COMMAND NOT RECOGNISED. USE help FOR COMMAND LIST. \n"

func go(arg: String):
	if arg.is_empty(): return "<ERROR> COMMAND ARGUMENT(S) NOT SPECIFIED. USE help FOR COMMAND LIST.\n"
	return "YOU WENT %s" % arg.to_upper()
	pass
