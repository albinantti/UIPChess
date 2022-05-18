extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_New_Game_pressed():
	get_node("New Game/NewGamePanel").visible = true
	get_node("LoadGame/LoadGamePanel").visible = false
	get_node("Tutorial/TutorialPanel").visible = false
	get_node("Settings/SettingsPanel").visible = false

func _on_LoadGame_pressed():
	get_node("New Game/NewGamePanel").visible = false
	get_node("LoadGame/LoadGamePanel").visible=true
	get_node("Tutorial/TutorialPanel").visible = false
	get_node("Settings/SettingsPanel").visible = false

func _on_Tutorial_pressed():
	get_node("New Game/NewGamePanel").visible = false
	get_node("LoadGame/LoadGamePanel").visible = false
	get_node("Tutorial/TutorialPanel").visible = true
	get_node("Settings/SettingsPanel").visible = false

func _on_Settings_pressed():
	get_node("New Game/NewGamePanel").visible = false
	get_node("LoadGame/LoadGamePanel").visible = false
	get_node("Tutorial/TutorialPanel").visible = false
	get_node("Settings/SettingsPanel").visible = true

func _on_ExitButton_pressed():
	get_node("New Game/NewGamePanel").visible = false
	get_node("LoadGame/LoadGamePanel").visible = false
	get_node("Tutorial/TutorialPanel").visible = false
	get_node("Settings/SettingsPanel").visible = false
