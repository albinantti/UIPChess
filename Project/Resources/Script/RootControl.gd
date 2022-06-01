extends Node

func _ready():
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	var error_code = get_tree().connect("node_added", self, "_on_SceneTree_node_added")
	if error_code != OK:
		print("ERROR: ", error_code)
	

func _on_SceneTree_node_added(node):
	if node is Button:
		connect_to_button(node)

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		if child is OptionButton:
			connect_to_item(child)
		connect_buttons(child)

func connect_to_button(button):
	var error_code = button.connect("pressed", self, "_on_Button_pressed")
	if error_code != OK:
		print("ERROR: ", error_code)
	
func connect_to_item(button):
	var error_code = button.connect("item_selected", self, "_on_Item_pressed")
	if error_code != OK:
		print("ERROR: ", error_code)

func _on_Button_pressed():
	self._play_sound()
	
func _on_Item_pressed(_item):
	self._play_sound()
	
func _play_sound():
	self.get_node("ButtonPressedSound").play()
