extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Display the correct mute button based on mute state
	if AudioServer.is_bus_mute(0):
		get_node("Unmute").visible = true
	else:
		get_node("Mute").visible = true


func _on_Mute_pressed():
	get_node("Unmute").visible = true
	get_node("Mute").visible = false
	AudioServer.set_bus_mute(0, 1)


func _on_Unmute_pressed():
	get_node("Unmute").visible = false
	get_node("Mute").visible = true
	AudioServer.set_bus_mute(0, 0)
