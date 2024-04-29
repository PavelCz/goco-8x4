class_name SFXPattern extends Resource

signal length_changed(length)
signal speed_changed(speed)

@export var length = 8: get = get_length, set = set_length # (int, 4, 32, 1)
@export var notes := [] # (Array, Resource)

# 1 = 1 note per second
@export var speed = 1: get = get_velocity, set = set_velocity # (int, 1, 32)


func _init():
	set_length(length)


func get_note_length() -> float:
	return 1.0 / speed


func set_length(l:int):
	length = l
	notes.resize(length)
	for i in length:
		if notes[i] == null:
			notes[i] = Note.new()
	
	emit_signal("length_changed", l)


func get_length() -> int:
	return length

func set_velocity(s:int):
	speed = s
	emit_signal("speed_changed", s)

func get_velocity() -> int:
	return speed

func get_length_seconds() -> float:
	return get_note_length() * length
