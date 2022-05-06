extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var difficulty = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameDifficultyEasy_pressed():
	difficulty = 1
	get_node("NewGameDifficultyEasy").set_modulate(Color("#bada55"))
	get_node("NewGameDifficultyMedium").set_modulate(Color("#ffffff"))
	get_node("NewGameDifficultyHard").set_modulate(Color("#ffffff"))
	get_node("../NewGameStartGame").check_validity()


func _on_NewGameDifficultyMedium_pressed():
	difficulty = 2
	get_node("NewGameDifficultyEasy").set_modulate(Color("#ffffff"))
	get_node("NewGameDifficultyMedium").set_modulate(Color("#bada55"))
	get_node("NewGameDifficultyHard").set_modulate(Color("#ffffff"))
	get_node("../NewGameStartGame").check_validity()


func _on_NewGameDifficultyHard_pressed():
	difficulty = 3
	get_node("NewGameDifficultyEasy").set_modulate(Color("#ffffff"))
	get_node("NewGameDifficultyMedium").set_modulate(Color("#ffffff"))
	get_node("NewGameDifficultyHard").set_modulate(Color("#bada55"))
	get_node("../NewGameStartGame").check_validity()

func get_difficulty():
	return difficulty
