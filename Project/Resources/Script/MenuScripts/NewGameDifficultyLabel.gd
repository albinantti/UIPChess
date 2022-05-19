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
	get_node("NewGameDifficultyEasy").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameSelectedButtonTheme.tres"))
	get_node("NewGameDifficultyMedium").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameButtonTheme.tres"))
	get_node("NewGameDifficultyHard").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameButtonTheme.tres"))
	
	get_node("../NewGameStartGame").check_validity()


func _on_NewGameDifficultyMedium_pressed():
	difficulty = 2
	get_node("NewGameDifficultyEasy").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameButtonTheme.tres"))
	get_node("NewGameDifficultyMedium").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameSelectedButtonTheme.tres"))
	get_node("NewGameDifficultyHard").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameButtonTheme.tres"))
	get_node("../NewGameStartGame").check_validity()


func _on_NewGameDifficultyHard_pressed():
	difficulty = 3
	get_node("NewGameDifficultyEasy").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameButtonTheme.tres"))
	get_node("NewGameDifficultyMedium").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameButtonTheme.tres"))
	get_node("NewGameDifficultyHard").set_theme(load("res://Resources/Themes/NewGameButtons/NewGameSelectedButtonTheme.tres"))
	get_node("../NewGameStartGame").check_validity()

func get_difficulty():
	return difficulty
