extends RichTextLabel

func _ready():
	install_effect(RainbowTextEffect.new())

func write(string: String):
	append_text(string)

func clear_():
	text = ""

