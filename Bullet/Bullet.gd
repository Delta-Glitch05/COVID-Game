extends RigidBody2D

var new_points = 1
var time = 0
const TIME_PERIOD = 0.5

func _process(delta):
	var n_enemy_gen = get_parent().get_node("Player").n_enemy_gen
	var colliders = get_colliding_bodies()
	self.scale = Vector2(2.5, 2.5)
	for collider in colliders:
		if "Enemy" in collider.get_groups():
			save(new_points)
			get_parent().get_node("Player").n_enemy_gen -= 1
			collider.queue_free()
			$Sounds/Hit.play()
			$Sounds/AbsorbingEnemy.play()
			yield(get_tree().create_timer(3.4), "timeout")
		#	$Sounds/EnemyCaught.play()
			queue_free()
	time += delta
	if(time > TIME_PERIOD):
		queue_free()
		time = 0


func save(new_points):
	var file = File.new()
	file.open("user://save_new_points.dat", File.WRITE)
	file.store_string(str(new_points))
	file.close()
