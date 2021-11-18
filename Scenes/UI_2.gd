extends CanvasLayer


func _ready():
	pass


func _on_KinematicBody2D_pokeball_signal(pokeball_count):
	$TextureRect/Label.text = str(pokeball_count)
