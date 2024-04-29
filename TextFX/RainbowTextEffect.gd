tool class_name RainbowTextEffect extends RichTextEffect

@export var start_color: Color = Color.AQUA
@export var end_color: Color = Color.PALE_GREEN

var bbcode := "rainbow"

func _process_custom_fx(char_fx : CharFXTransform) -> bool:
	var index = float(char_fx.absolute_index)
	
	var time = char_fx.elapsed_time + index
	
	char_fx.color = lerp(start_color, end_color, sin(time))
	
	return true
