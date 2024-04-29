class_name UploadCommand extends ConsoleCommand

func _disconnect_all():
	if ES.console.gocoNet.is_connected("upload_success", Callable(self, "_on_upload_success")):
		ES.console.gocoNet.disconnect("upload_success", Callable(self, "_on_upload_success"))
	if ES.console.gocoNet.is_connected("upload_failed", Callable(self, "_on_upload_failed")):
		ES.console.gocoNet.disconnect("upload_failed", Callable(self, "_on_upload_failed"))
	

func run(args:Array = []):
	if args.size() == 0:
		ES.error("Please specify a game file.")
		return COMMAND_ERROR
	
	if not ES.console.gocoNet.logged_in:
		ES.error("Not logged in. Log in using the login command: login [username] [password]")
		return COMMAND_ERROR
	
	var path = (ES.console.dir + "/" + args[0]).replace('///', '//')
	if not ES.console.gocoNet.is_connected("upload_success", Callable(self, "_on_upload_success")):
		ES.console.gocoNet.connect("upload_success", Callable(self, "_on_upload_success"))
	if not ES.console.gocoNet.is_connected("upload_failed", Callable(self, "_on_upload_failed")):
		ES.console.gocoNet.connect("upload_failed", Callable(self, "_on_upload_failed"))
	
	
	var f = File.new()
	if not f.file_exists(path):
		ES.error(path + " does not eixst.")
		return COMMAND_ERROR
	
	var err = f.open(path, File.READ)
	if err:
		ES.error("Failed to open " + path + ". Err: " + str(err))
		return COMMAND_ERROR
	
	# unpack game to check for title and version
	var packed_project = ES.packer.unpack(path)
	
	# get game data and convert to base64
	var game = f.get_buffer(f.get_length())
	var game_base64 = Marshalls.raw_to_base64(game)
	
	f.close()
	
	ES.console.gocoNet.upload(packed_project, game_base64)
	
	return OK


func _on_upload_success(response_code, message):
	ES.echo("Upload completed.")


func _on_upload_failed(result, response_code, headers, body):
	ES.error("Upload failed:" + body.get_string_from_utf8())
