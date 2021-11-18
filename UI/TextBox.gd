extends NinePatchRect


signal dialogue_finished


func _ready():
	set_process(false)
	hide()


func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		hide()
		set_process(false)
		emit_signal("dialogue_finished")


func _on_KinematicBody2D_dialogue_started(dialogue_text):
	$Label.text = dialogue_text
	show()
	set_process(true)
