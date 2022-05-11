extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	# pass
		

# Changes button color, basically


# Checks if all settings have been entered so the game can be started.
func check_validity():
	if(get_node("../NewGameOpponentLabel").get_opponent() == "cpu"):
		if(get_node("../NewGameDifficultyLabel").get_difficulty() > 0):
			self.disabled = false
		else:
			self.disabled = true
	elif(get_node("../NewGameOpponentLabel").get_opponent() == "human"):
		self.disabled = false
		


func _on_NewGameStartGame_pressed():
	get_tree().change_scene("res://GameScene.tscn")

