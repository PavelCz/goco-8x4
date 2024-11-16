class_name HelpPanel extends MarginContainer

var is_visible:bool = false


@warning_ignore("native_method_override")
func show():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	
	$AnimationPlayer.play("show")
	is_visible = true

@warning_ignore("native_method_override")
func hide():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	
	$AnimationPlayer.play_backwards("show")
	is_visible = false


func toggle():
	if is_visible:
		hide()
	else:
		show()
