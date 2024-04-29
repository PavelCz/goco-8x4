tool class_name TilesetTile extends Control

signal button_down()
signal button_up()
signal changed()

var tileset:Tileset: get = get_tileset, set = set_tileset
@export var region: Rect2: get = get_region, set = set_region_enabled
@export var render_size: int = 16: get = get_render_size, set = set_render_size

var pressed:bool = false: get = get_pressed, set = set_pressed

func set_pressed(p:bool):
	pressed = p
	update()

func get_pressed() -> bool:
	return pressed

func set_tileset(t:Tileset):
	if tileset:
		tileset.disconnect("changed", Callable(self, "update"))
	
	tileset = t
	tileset.connect("changed", Callable(self, "update"))

func get_tileset() -> Tileset:
	return tileset

func set_region_enabled(r:Rect2):
	region = r

func get_region() -> Rect2:
	return region

func set_render_size(s: int):
	render_size = s
	custom_minimum_size.x = render_size + 4
	custom_minimum_size.y = render_size + 4

func get_render_size() -> int:
	return render_size

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("button_down")
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			emit_signal("button_up")
			get_viewport().set_input_as_handled()
	elif event.is_action("copy") and event.pressed:
		_copy_region_to_clipboard()
		get_viewport().set_input_as_handled()
	elif event.is_action("cut") and event.pressed:
		_cut_region_to_clipboard()
		get_viewport().set_input_as_handled()
	elif event.is_action("paste") and event.pressed:
		_paste_from_clipboard()
		get_viewport().set_input_as_handled()

func _copy_region_to_clipboard():
	print("copying")
	var sub_image = tileset.image.get_rect(region)
	var clipboard = ClipboardItem.new(ClipboardItem.TYPE.IMAGE, sub_image)
	ES.clipboard_set(clipboard)

func _cut_region_to_clipboard():
	var sub_image = tileset.image.get_rect(region)
	var clipboard = ClipboardItem.new(ClipboardItem.TYPE.IMAGE, sub_image)
	
	# fill with transparent
	tileset.image.fill_rect(region, Color.TRANSPARENT)
	ES.clipboard_set(clipboard)

func _paste_from_clipboard():
	if ES.clipboard and ES.clipboard.type == ClipboardItem.TYPE.IMAGE:
		var img = ES.clipboard.get_data()
		tileset.image.blit_rect(img, Rect2(0, 0, img.get_size().x, img.get_size().y), region.position)
		tileset.update_texture()
		emit_signal("changed")
		

func _draw():
	var border_color = Color.BLACK
	if pressed:
		border_color = Color.WHITE
	
	draw_rect(Rect2(0, 0, render_size + 2, render_size + 2), border_color, false, 2.0)
	
	if tileset:
		draw_texture_rect_region(tileset.texture, Rect2(1, 1, render_size, render_size), region)
