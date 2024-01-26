extends CheckButton

var music_bus = AudioServer.get_bus_index("Master")

func _on_pressed():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))


func _ready():
	button_pressed = AudioServer.is_bus_mute(music_bus)
