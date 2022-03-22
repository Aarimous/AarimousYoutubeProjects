extends Control

var _audioScale = 20

func _ready():
	visible = false
	

func _on_HSlider_value_changed(value):
	if(value == $MarginContainer/VBoxContainer/HBoxContainer/HSlider.min_value):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _audioScale * value/100)
