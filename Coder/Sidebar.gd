extends VBoxContainer

var is_visible:bool = false

func show_():
	$AnimationPlayer.play("show")
	is_visible = true
	$Tree.grab_focus_()
	if $Tree.get_child_count() > 1:
		$Tree.get_child(1).grab_focus_()

func hide_():
	$AnimationPlayer.play_backwards("show")
	is_visible = false
