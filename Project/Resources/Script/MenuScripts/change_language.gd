extends OptionButton

var english_id = 0
var swedish_id = 1

func _ready():
	self.connect("item_selected", self, "on_item_selected")
	var current_locale = TranslationServer.get_locale()
	if current_locale.begins_with("sv"):
		self.select(swedish_id)
	else:
		self.select(english_id)
		

func on_item_selected(index):
	var new_locale = "sv" if index == 1 else "en"
	TranslationServer.set_locale(new_locale)
