class_name Tileset extends RefCounted

signal changed()

var path:String
var filename:String
var title:String
var tile_size:int

var saved:bool = false

var image:Image
var texture:ImageTexture

var tile_meta = {}

func create(path:String, title:String, width: int, height: int, tile_size:int = 8):
	self.path = path
	self.title = title
	self.tile_size = tile_size
	image = Image.new()
	image.create(width, height, false, Image.FORMAT_RGBA8)
	false # image.lock() # TODOConverter3To4, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	texture = ImageTexture.new()
	texture.create_from_image(image) #,0
	saved = false


func get_region(index:int):
	var columns = int(image.get_size().x) / tile_size
	var x = index % columns
	var y = index / columns
	return Rect2(x * tile_size, y * tile_size, tile_size, tile_size)


func update_texture():
	saved = false
	texture.set_data(image)
	emit_signal("changed")


func save_file():
	false # image.unlock() # TODOConverter3To4, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	var err = image.save_png(path)
	false # image.lock() # TODOConverter3To4, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed

	if err:
		ES.echo("Failed to save image to path " + path + ". Err:" + str(err))
		return false
	return true


func pack(project) -> Dictionary:
	var packed = {
		"path": path.trim_prefix(project.get_tilesets_dir() + "/"),
		"title": title,
		"filename": filename,
		"tile_size": tile_size,
		"tile_meta": tile_meta,
		"image_data": image.get_data(),
		"image_width": image.get_width(),
		"image_height": image.get_height()
	}
	return packed


func unpack(project, packed: Dictionary):
	self.path = project.get_tilesets_dir("/" + packed.path)
	title = packed.title
	filename = packed.filename
	tile_size = packed.tile_size
	tile_meta = packed.tile_meta
	var img_data = packed.image_data
	image = Image.new()
	image.create_from_data(packed.image_width, packed.image_height, false, Image.FORMAT_RGBA8, packed.image_data)
	texture = ImageTexture.new()
	texture.create_from_image(image) #,0


func serialize(project) -> Dictionary:
	return {
		"path": path.trim_prefix(project.get_tilesets_dir() + "/"),
		"title": title,
		"filename": filename,
		"tile_size": tile_size,
		"tile_meta": tile_meta
	}


func unserialize(project, data:Dictionary):
	self.path = project.get_tilesets_dir("/" + data.path)
	filename = data.filename
	tile_size = data.tile_size
	tile_meta = data.tile_meta
	title = data.title

	load_file()


func load_file():
	var f = File.new()
	var err = f.open(path, File.READ)
	if err:
		ES.echo("Failed to open image at " + path + ". Err:" + str(err))
		return false

	var buffer = f.get_buffer(f.get_length())
	f.close()

	image = Image.new()
	image.load_png_from_buffer(buffer)

	texture = ImageTexture.new()
	texture.create_from_image(image) #,0


