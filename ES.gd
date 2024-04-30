extends Node

signal clipboard_set(item)

const VERSION := "0.10.0"

enum COLORS {
	
}

var scene_arguments := {}
var current_scene = null

var console
var editor
var escript = EScript.new()
var packer:Packer = Packer.new()

var clipboard:ClipboardItem = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func clipboard_set2(clipboard_item:ClipboardItem):
	clipboard = clipboard_item
	emit_signal("clipboard_set", clipboard)

func has_clipboard() -> bool:
	return clipboard != null

func clipboard_get() -> ClipboardItem:
	return clipboard

func project_folder_exists(project:String):
	return DirAccess.dir_exists_absolute("user://projects/" + project)

func open_project(project:String):
	editor.open_project(project)
	return true


func echo(what:String, color:String = "white"):
	print(what)
	
	if is_instance_valid(console):
		if color != "white":
			what = "[color=" + color + "]" + what + "[/color]"
		console.write(what)


func error(message:String):
	echo("Error: " + message, "red")
	if is_instance_valid(editor):
		editor.notify("ERROR: " + message)


func push_log_to_console():
	var log_file_path = "user://logs/godot.log"
	if FileAccess.file_exists(log_file_path):
		var log_file = FileAccess.open(log_file_path, FileAccess.READ)
		if log_file == null:
			error(
				"Failed to open logfile at " + str(log_file_path) 
				+ ". Err: " + str(FileAccess.get_open_error())
			)
		else:
			var messages:String = log_file.get_as_text()
			var regex = RegEx.new()
			
			# remove warnings
			regex.compile("\nWARNING: .+")
			var matches:Array = regex.search_all(messages)
			for m in matches:
				for string in m.strings:
					messages = messages.replace(string, "")
			
			# colorize errors
			regex.compile("\nSCRIPT ERROR: .+")
			matches = regex.search_all(messages)
			for m in matches:
				for string in m.strings:
					messages = messages.replace(string, "[color=red]" + string + "[/color]")
			
			echo(messages)
			
			if editor and matches.size() > 0:
				var errors = matches.size()
				error(str(errors) + " Errors occured.")
			


func clear_log_file():
	var file_path = "user://logs/godot.log"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		error(
				"Failed to clear log file. Err: " + 
				str(FileAccess.get_open_error())
		)


func goto_scene(path, arguments := {}):
	scene_arguments = arguments.duplicate(true)
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().current_scene = current_scene


#-----------------------#
#  UTILS
#-----------------------#
func join(array:Array, separator:String = ""):
	var string = ""
	var i = 0
	for element in array:
		string += element
		if i < array.size() - 1:
			string += separator
		i += 1
	return string
