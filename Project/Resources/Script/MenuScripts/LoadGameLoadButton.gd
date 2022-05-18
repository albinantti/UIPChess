extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("../LoadedFileLabel").set_text(tr("LOAD_GAME_LOADED_FILE").format({file=tr("CONSTANT_NONE")}))



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LoadGameSelectFileButton_pressed():
	self.get_node("LoadGameFileDialog").popup_centered()



func _on_LoadGameFileDialog_file_selected(path):
	self.get_node("../LoadedFileLabel").set_text(tr("LOAD_GAME_LOADED_FILE").format({file=tr(path)}))
	self.disabled = false
	
func _pressed():
	var error_code = get_tree().change_scene("res://GameScene.tscn")
	if error_code != OK:
		print("ERROR: ", error_code)
