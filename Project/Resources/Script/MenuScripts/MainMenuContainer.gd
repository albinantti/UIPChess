extends GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the mute switch to the current mute state
	var mute_switch = get_node("Settings/SettingsPanel/SettingsScrollBox/SettingsBox/Mute/MuteSwitch")
	mute_switch.pressed = AudioServer.is_bus_mute(0)


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

# Sets audio bus mute state to value of mute button on press
func _on_MuteSwitch_toggled(button_pressed):
	AudioServer.set_bus_mute(0, button_pressed)
