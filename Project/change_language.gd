extends Button

func _pressed():
	var current_locale = TranslationServer.get_locale()
	var new_locale = "sv" if current_locale == "en" else "en"

	TranslationServer.set_locale(new_locale)
