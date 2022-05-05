extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("ExitConfirmation").get_ok().connect("pressed", self, "confirmed")
	self.get_node("ExitConfirmation").get_close_button().hide()


func _pressed():
	self.get_node("ExitConfirmation").popup_centered_minsize()
	
	
func confirmed():
	get_tree().quit()
