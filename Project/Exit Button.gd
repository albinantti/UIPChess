extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	self.get_node("ExitConfirmation").get_ok().connect("pressed", self, "confirmed")
	self.get_node("ExitConfirmation").get_close_button().hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _pressed():
	self.get_node("ExitConfirmation").popup_centered_minsize()
	
	
func confirmed():
	get_tree().quit()
