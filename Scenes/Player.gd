extends KinematicBody2D


const TIME_PERIOD = 5
const ENEMY_SPAWN_PERIOD = 0.5
const MAX_ENEMY_NUM = 4
var time = 0
var n_enemy_gen = 1
var content
var max_health = 100
var health = 100
var win = false


func _ready():
	randomize()
	var file = File.new()
	file.open("user://save_new_points.dat", File.WRITE)
	file.store_string("0")
	file.close()
#	var t = Timer.new()
#	t.set_wait_time(5)
#	t.set_one_shot(true)
#	self.add_child(t)
#	t.start()
#	yield(t, "timeout")
#	t.queue_free()
#	self.position.x = 300
#	self.position.y = 200
#	print(self.position)

var bullet_count = 500
var new_points = 0
var first_win_anim = true
var second_win_anim = false
var third_win_anim = false
var fourth_win_anim = false
var fifth_win_anim = false
var sixth_win_anim = false
var seventh_win_anim = false

signal dialogue_started
signal points_signal
signal win
signal game_over
signal bullet_signal

func _process(delta):
	var velocity = Vector2()
	if !win:
		if Input.is_action_pressed("move_up"):
			velocity.y = -1
			$RayCast2D.cast_to = Vector2(0, -15)
			$RayCast2D.scale = Vector2(50, 23)
		if Input.is_action_pressed("move_down"):
			velocity.y = 1
			$RayCast2D.cast_to = Vector2(0, 15)
			$RayCast2D.scale = Vector2(50, 23)
		if Input.is_action_pressed("move_left"):
			velocity.x = -1
			$RayCast2D.cast_to = Vector2(-15, 0)
			$RayCast2D.scale = Vector2(18, 0)
		if Input.is_action_pressed("move_right"):
			velocity.x = 1
			$RayCast2D.cast_to = Vector2(15, 0)
			$RayCast2D.scale = Vector2(18, 0)
		var movement = velocity.normalized() * 500 * delta
		self.move_and_collide(movement)
		self.update_animations(velocity)
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider and Input.is_action_just_released("ui_accept") and "NPC" in collider.name:
				emit_signal("dialogue_started", collider.dialogue_text)
				$Player.stop()
				set_process(false)
		if bullet_count > 0 and $BulletCooldown.time_left == 0 and Input.is_action_just_pressed("shoot_bullet"):
			$BulletCooldown.start()
			bullet_count -= 1
			shoot_bullet(delta)
			$BulletThrownSound.play()
		time += delta
		if time > TIME_PERIOD:
			emit_signal("timeout")
			time = 0
		if time > ENEMY_SPAWN_PERIOD:
			#print(self.position)
			#print(n_enemy_gen)
			if n_enemy_gen <= MAX_ENEMY_NUM:
				n_enemy_gen += 1
				spawn_enemy()
			time = 0
		#if n_enemy_gen == MAX_ENEMY_NUM:
		#	n_enemy_gen = content
		if(self.position.x > -1350 and self.position.x < -1100 and self.position.y > -4750 and self.position.y < -4600):
			emit_signal("win")
			#$Win.visible = true
			win = true
		new_points = int(load_())
		emit_signal("points_signal", new_points)
	else:
		win(delta, velocity)


func win(delta, velocity):
	if first_win_anim:
		$HealthDisplay.visible = false
		if self.position.x < -1222:
			$Player.play("walk_left")
			$Player.flip_h = true
			velocity.x = 1
			var movement = velocity.normalized() * 150 * delta
			self.move_and_collide(movement)
		elif self.position.x > -1218:
			$Player.play("walk_left")
			$Player.flip_h = false
			velocity.x = -1
			var movement = velocity.normalized() * 150 * delta
			self.move_and_collide(movement)
		else:
			$Player.play("stand_up")
			first_win_anim = false
			second_win_anim = true
	if second_win_anim:
		var t = Timer.new()
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		if self.position.y < -4600 and self.position.y > -4730:
			$Player.play("walk_up")
			velocity.y = -1
			var movement = velocity.normalized() * 150 * delta
			self.move_and_collide(movement)
		else:
			$Player.visible = false
			second_win_anim = false
			third_win_anim = true
	if third_win_anim:
		var t = Timer.new()
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		if self.position.y < -4610:
			$Player.visible = true
			$Player.play("walk_down")
			velocity.y = 1
			var movement = velocity.normalized() * 100 * delta
			self.move_and_collide(movement)
		else:
			$Player.play("stand_down")
			third_win_anim = false
			fourth_win_anim = true
	if fourth_win_anim:
		var movement
		first_win_anim = false
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		fourth_win_anim = false
		fifth_win_anim = true
	if fifth_win_anim:
		if self.position.x < -500:
			$Player.play("walk_left")
			$Player.flip_h = true
			velocity.x = 1
			var movement = velocity.normalized() * 120 * delta
			self.move_and_collide(movement)
		else:
			$Player.play("stand_up")
			fifth_win_anim = false
			sixth_win_anim = true
	if sixth_win_anim:
		if self.position.y < -4605 and self.position.y > -4650:
			var t = Timer.new()
			t.set_wait_time(0.8)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			$Player.play("walk_up")
			velocity.y = -1
			var movement = velocity.normalized() * 100 * delta
			self.move_and_collide(movement)
		else:
			sixth_win_anim = false
			seventh_win_anim = true
	if seventh_win_anim:
		get_parent().get_node("UI/Slogan").visible = true
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		$Player.speed_scale = 0.5
		$Player.play("move_arms")


func load_():
	var file = File.new()
	file.open("user://save_new_points.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	var file_2 = File.new()
	file_2.open("user://save_new_points.dat", File.WRITE)
	file_2.store_string("0")
	file_2.close()
	return content


func update_animations(velocity):
	if velocity.y == 1:
		$Player.play("walk_down")
	if velocity.y == -1:
		$Player.play("walk_up")
	elif velocity.x == -1:
		$Player.play("walk_left")
		$Player.flip_h = false
	elif velocity.x == 1:
		$Player.play("walk_left")
		$Player.flip_h = true
	if velocity == Vector2():
		if $Player.animation == "walk_down":
			$Player.play("stand_down")
		elif $Player.animation == "walk_up":
			$Player.play("stand_up")
		elif $Player.animation == "walk_left":
			$Player.play("stand_left")


func shoot_bullet(delta):
	var bullet_scene = load("res://Bullet/Bullet.tscn")
	var bullet_node = bullet_scene.instance()
	bullet_node.position = self.position + $RayCast2D.cast_to.normalized()*32
	bullet_node.apply_impulse(Vector2(), $RayCast2D.cast_to.normalized()*1800)
	#bullet_node.set_angular_velocity(30)
	get_node("/root/Node").add_child(bullet_node)
	emit_signal("bullet_signal", bullet_count)
	time += delta
	if time > TIME_PERIOD:
		bullet_node.queue_free()


func _on_TextBox_dialogue_finished() -> void:
	set_process(true)


func spawn_enemy():
	var enemy = load("res://Scenes/Enemy.tscn")
	var enemy_node = enemy.instance()
	get_node("/root/Node").add_child(enemy_node)
	enemy_node.position = self.position
	enemy_node.scale = Vector2(2.5, 2.5)
	var random_x = randf()
	var random_y = randf()
	if random_x < 0.25:
		enemy_node.position.x += -400
	elif random_x >= 0.25 and random_x < 0.5:
		enemy_node.position.x += 400
	elif random_x >= 0.5 and random_x < 0.75:
		enemy_node.position.x += -400
	else:
		enemy_node.position.x += 400
	if random_y < 0.25:
		enemy_node.position.y += -400
	elif random_y >= 0.25 and random_y < 0.5:
		enemy_node.position.y += 400
	elif random_y >= 0.5 and random_y < 0.75:
		enemy_node.position.y += -400
	else:
		enemy_node.position.y += 400


func update_healthbar():
	health -= 0.25
	$HealthDisplay.update_healthbar(health)
	if health <= 0:
		emit_signal("game_over")
		#$Game_Over.visible = true
		#get_tree().paused = true


func read_health():
	var file = File.new()
	file.open("user://player_health.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content
