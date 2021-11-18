extends KinematicBody2D

var movement = Vector2()
var speed = 250
var velocity = Vector2.ZERO
var player = null
var player_health = 100
var time = 0
var temp_health = 100

func _ready():
	randomize()


func _physics_process(delta):
	if !get_parent().get_node("Player").win:
		var collision = move_and_collide(velocity * delta)
		velocity = Vector2.ZERO
		if("Kinematic" in str(player)):
			velocity = position.direction_to(player.position) * speed
			velocity = move_and_slide(velocity)
		if(collision):
			if(collision.get_class() == "KinematicCollision2D"):
				time += delta
				var t = Timer.new()
				t.set_wait_time(0.5)
				t.set_one_shot(false)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				if !get_parent().get_node("Player").win:
					get_parent().get_node("Player").update_healthbar()
	else:
		self.queue_free()


func get_random_direction():
	var random_direction = Vector2()
	var random_float = randf()
	if random_float < 0.25:
		random_direction.x = -1
	elif random_float >= 0.25 and random_float < 0.5:
		random_direction.x = 1
	elif random_float >= 0.5 and random_float < 0.75:
		random_direction.y = -1
	else:
		random_direction.y = 1
	return random_direction


func _on_Area2D_body_entered(body):
	player = body


func _on_Area2D_body_exited(body):
	player = null
