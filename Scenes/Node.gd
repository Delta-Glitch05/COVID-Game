extends Node

var health = 0

func _ready():
	var file = File.new()
	file.open("user://player_health.dat", File.WRITE)
	file.store_string("100")
	file.close()
