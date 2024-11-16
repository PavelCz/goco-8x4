extends TabContainer

func grab_focus_():
	if get_child_count() > 0:
		get_child(current_tab).grab_focus_()

func clear():
	return
	for child in get_children():
		remove_child(child)
		child.queue_free()
