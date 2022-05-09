extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var opponent = "none"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameOpponentCPU_pressed():
	opponent = "cpu"
	get_node("NewGameOpponentCPU").set_theme(load("res://Resources/Themes/NewGameSelectedButtonTheme.tres"))
	get_node("NewGameOpponentHuman").set_theme(load("res://Resources/Themes/NewGameButtonTheme.tres"))
	get_node("../NewGameDifficultyLabel").visible = true
	get_node("../NewGameStartGame").check_validity()


func _on_NewGameOpponentHuman_pressed():
	opponent = "human"
	get_node("NewGameOpponentCPU").set_theme(load("res://Resources/Themes/NewGameButtonTheme.tres"))
	get_node("NewGameOpponentHuman").set_theme(load("res://Resources/Themes/NewGameSelectedButtonTheme.tres"))
	get_node("../NewGameDifficultyLabel").visible = false
	get_node("../NewGameStartGame").check_validity()

func get_opponent():
	return opponent
