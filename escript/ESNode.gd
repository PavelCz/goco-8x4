class_name ESNode extends RefCounted

var production:int = 0
var children:Array = []
var name:String = "ESNode"

func add(child):
	children.append(child)

func backtrack(amount:int):
	while(amount > 0):
		children.pop_back()
		amount -= 1
		

func remove_child(child):
	children.remove_at(children.find(child))


func remove_all_tokens_of_type(type:int):
	for child in children:
		if child is Token and child.type == type:
			remove_child(child)

func first_token(type:int = -1):
	for child in children:
		if child is Token:
			if type == -1 or type == child.type:
				return child
	return null


func last_token(type:int = -1):
	children.reverse()
	for child in children:
		if child is Token:
			if type == -1 or type == child.type:
				return child
	# TODO: Not 100% sure we want to do this here...
	children.reverse()


func cleanup():
	pass

func parse_1(parser):
	pass

func compile(compiler:Compiler):
	for child in children:
		if child.has_method("compile"):
			child.compile(compiler)
