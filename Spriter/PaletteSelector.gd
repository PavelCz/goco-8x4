tool class_name PaletteSelector extends Control

signal color_selected()

@export var bg_color: Color = Color(0.03, 0.03, 0.03)
@export var selected_color: int = 0: get = get_selected, set = set_selected
@export var palette # (Array, Color)
@export var swatch_size: int = 8: get = get_swatch_size, set = set_swatch_size
@export var rows: int = 2: get = get_rows, set = set_rows
var columns:int = 0

func set_selected(i:int):
	selected_color = i
	update()
	emit_signal("color_selected", get_selected_color())

func get_selected() -> int:
	return selected_color

func get_selected_color() -> Color:
	return palette[selected_color]

func set_swatch_size(ss:int):
	swatch_size = ss
	_recalculate_size()
	update()

func get_swatch_size() -> int:
	return swatch_size

func set_rows(r:int):
	rows = r
	columns = palette.size() / rows
	_recalculate_size()
	update()

func get_rows() -> int:
	return rows

func _recalculate_size():
	# calculate size
	custom_minimum_size.x = columns * swatch_size
	custom_minimum_size.y = swatch_size * rows

func get_swatch_at(x, y) -> int:
	x = floor(x / swatch_size)
	y = floor(y / swatch_size)
	var swatch = x + columns * y
	if swatch < 0:
		swatch = 0
	elif swatch > palette.size() - 1:
		swatch = palette.size() - 1
	return swatch

func get_swatch_coord(i:int) -> Vector2:
	var x = (i % columns) * swatch_size
	var y = floor(i / columns) * swatch_size
	return Vector2(x, y)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var pos = event.position
			var i = get_swatch_at(pos.x, pos.y)
			set_selected(i)

func _draw():
	var rect = get_rect()
	var size = custom_minimum_size
	
	# draw background
	draw_rect(Rect2(0, 0, size.x, size.y), bg_color, true, 0)# false) TODOConverter3To4 Antialiasing argument is missing
	
	# draw swatches
	var x = 0
	var y = 0
	var i = 0
	for swatch in palette:
		x = (i % columns) * swatch_size
		y = floor(i / columns) * swatch_size
		
		draw_rect(Rect2(x, y, swatch_size, swatch_size), swatch, true, 1.0)# false) TODOConverter3To4 Antialiasing argument is missing
		
		i += 1
	
	# draw selection border
	var coord = get_swatch_coord(selected_color)
	var color = palette[selected_color]
	draw_rect(Rect2(coord.x + 1, coord.y + 1, swatch_size - 2, swatch_size - 2), Color.GRAY, false, 2.0)# false) TODOConverter3To4 Antialiasing argument is missing
	draw_rect(Rect2(coord.x + 2, coord.y + 2, swatch_size - 4, swatch_size - 4), Color.WHITE, false, 2.0)# false) TODOConverter3To4 Antialiasing argument is missing
