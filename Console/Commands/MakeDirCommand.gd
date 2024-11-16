class_name MakeDirCommand extends ConsoleCommand

func run(args:Array = []):
	if args.size() == 0:
		ES.echo("mkdir needs a folder name!")
		return ERR_PARAMETER_RANGE_ERROR
	
	var name = args[0]
	var dir = DirAccess.open(ES.console.dir)
	dir.make_dir(name)
	if dir == null:
		ES.echo(str(DirAccess.get_open_error()))
		return DirAccess.get_open_error()
	else:
		return OK
