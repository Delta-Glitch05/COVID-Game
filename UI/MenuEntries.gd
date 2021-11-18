extends VBoxContainer


onready var disabled_entries = [
	$Options
]
onready var new_entry = $SinglePlayer

func _ready():
	for entry in disabled_entries:
		entry.modulate.a = 0.3
		entry.focus_mode = Control.FOCUS_NONE
	if Input.is_action_just_pressed("move_down"):
		new_entry = $SinglePlayer
		new_entry.modulate.a = 0.3
		new_entry.focus_mode = Control.FOCUS_NONE
