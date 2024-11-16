class_name Packer extends RefCounted

var games_dir_checked:bool = false

func _check_games_dir():
	var dir = DirAccess.open("user://")
	if dir == null:
		ES.error(	
			"Cannot open user://. Err: " + str(DirAccess.get_open_error())
		)
		return
	
	if not dir.dir_exists("games"):
		var err = dir.make_dir("games")
		if err != OK:
			ES.error("Failed to create user://games directory. Err: " + str(err))
		else:
			ES.echo("Created user://games directory.")
	games_dir_checked = true


# pack a project
func pack(project:Project):
	if not games_dir_checked:
		_check_games_dir()
	
	var project_directory
	
	var packed_project = project.pack()
	
	var file_name = "user://projects/" + project.name + "/" + project.name + ".g8"
	
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	if file == null:
		ES.error("Failed to open " + file_name + ". Err: " + str(FileAccess.get_open_error()))
	else:
		file.store_var(packed_project, true)
		file.close()
		ES.echo("Project packed to " + file_name + ".")


func unpack_and_save(game_file_path: String, project_name:String = "") -> Project:
	
	if not FileAccess.file_exists(game_file_path):
		ES.error("Game file not found: " + game_file_path)
		return null
	
	var game_file = FileAccess.open(game_file_path, FileAccess.READ)
	if game_file == null:
		ES.error("Failed to open game_file at " + str(game_file_path) + ". Err: " + str(FileAccess.get_open_error()))
		return null
	
	var packed_project = game_file.get_var(true)
	
	game_file.close()
	
	# why wasnt this being done already?
	if project_name == "":
		project_name = packed_project.name
	
	var project = Project.new(project_name)
	project.unpack(packed_project)
	project.save_data(true)
	
	for scripts in packed_project.scripts:
		print("Saving script file")
	
	return project
