extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _pressed():
	# Set my primitive tutorial audio bus flag to true
	AudioServer.add_bus()
	AudioServer.set_bus_mute(1, 1)
	var error_code = get_tree().change_scene("res://GameScene.tscn")
	if error_code != OK:
		print("ERROR: ", error_code)
