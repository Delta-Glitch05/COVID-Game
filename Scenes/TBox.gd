extends NinePatchRect

signal dialogue_finished

func _ready():
	set_process(false)
	hide()


func _process(delta):
	#hide()
	set_process(false)
	emit_signal("dialogue_finished")


#func _talk(dialogue_text):
#	$Label.text = dialogue_text
#	show()
#	set_process(true)


func _on_Black_Screen_dialogue_started(dialogue_text):
	$Label.text = dialogue_text
	show()
	set_process(true)
