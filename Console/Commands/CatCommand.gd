class_name CatConsoleCommand extends ConsoleCommand

func run(args:Array = []):
	if args.size() == 0:
		ES.echo("Cat command expects 1 argument.")
		return COMMAND_ERROR
	var file:String = str(args[0])
	file = file.lstrip("/")
	file = (ES.console.dir + "/").replace("///", "//") + file
	var f = FileAccess.open(file, FileAccess.READ)
	if f == null:
		ES.echo("Failed to open file at " + str(file) + ". Err: " + str(FileAccess.get_open_error()))
		return COMMAND_ERROR
	else:
		var text = f.get_as_text()
		f.close()
		ES.echo("file at " + file, "gray")
		ES.echo(text)
	return OK
