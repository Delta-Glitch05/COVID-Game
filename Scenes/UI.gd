extends CanvasLayer

var max_points = 0
var check = 0

func _ready():
	max_points = get_max_points()
#	print(max_points)
#	print($Max_Points.text)


var points = 0
func _on_Player_bullet_signal(bullet_count):
	pass


func get_max_points():
	var max_points_file = File.new()
	max_points_file.open("user://max_points.dat", File.READ)
	max_points = int(max_points_file.get_as_text())
	max_points_file.close()
	$Max_Points.text = "Punteggio Massimo: " + str(max_points)
	return max_points


func _on_Player_game_over():
	$Game_Over.visible = true


func _on_Player_points_signal(new_points):
	points += new_points
	$Points.text = "Punti: " + str(points)
	if(points > max_points):
		var save_max_points = File.new()
		save_max_points.open("user://max_points.dat", File.WRITE)
		save_max_points.store_string(str(points))
		save_max_points.close()
		check = get_max_points()


func _on_Player_win():
	$Win.visible = true
