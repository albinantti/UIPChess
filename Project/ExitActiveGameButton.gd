extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("ExitConfirmationPopup").get_ok().connect("pressed", self, "confirmed")
	self.get_node("ExitConfirmationPopup").get_ok().set_text("POPUP_OK")
	self.get_node("ExitConfirmationPopup").get_cancel().set_text("POPUP_CANCEL")
	self.get_node("ExitConfirmationPopup").get_close_button().hide()


func _pressed():
	self.get_node("ExitConfirmationPopup").popup_centered_minsize(Vector2( 200.0, 100.0 ))


func confirmed():
	get_tree().change_scene("res://mainMenu.tscn")
