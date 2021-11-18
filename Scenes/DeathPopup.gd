extends Popup


onready var player = get_parent().get_parent().get_node("Player")
var selected_menu
var appear = false
var first_appear = true


func _ready():
	pass


func change_menu_color():
	$Restart.color = Color.gray
	$Quit.color = Color.gray
	match selected_menu:
		0:
			$Restart.color = Color.greenyellow
		1:
			$Quit.color = Color.greenyellow


func _process(event):
	if appear:
		if first_appear:
			print(selected_menu)
			get_tree().paused = true
			selected_menu = 0
			change_menu_color()
			player.set_process_input(false)
			popup()
			first_appear = false
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			if selected_menu == 0:
				selected_menu = 1
			else:
				selected_menu = 0
			change_menu_color()
		elif Input.is_action_just_pressed("ui_accept"):
			match selected_menu:
				0:
					get_tree().change_scene("res://Scenes/Game.tscn")
					get_tree().paused = false
					appear = false
				1:
					get_tree().quit()


func _on_Player_game_over():
	appear = true
