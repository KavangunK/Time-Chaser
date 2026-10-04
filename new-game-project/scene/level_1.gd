extends Node2D

@export var survive_time := 60.0
var astroid_scene := preload("res://scene/astroid.tscn")
var time_left := 0.0
var won := false

func _ready() -> void:
	time_left = survive_time
	$SpawnTimer.wait_time = 1.0
	$SpawnTimer.timeout.connect(spawn_astroid)
	$SpawnTimer.start()

func _process(delta: float) -> void:
	if won:
		return
	time_left -= delta
	$UI/TimeLabel.text = "Survive: %d" % ceili(maxf(time_left, 0))
	if time_left <= 0:
		win()

func spawn_astroid() -> void:
	# Pick a random spot just outside one of the 4 screen edges
	var area := get_viewport_rect().grow(80)
	var pos: Vector2
	match randi() % 4:
		0: pos = Vector2(area.position.x, randf_range(area.position.y, area.end.y))  # left
		1: pos = Vector2(area.end.x, randf_range(area.position.y, area.end.y))       # right
		2: pos = Vector2(randf_range(area.position.x, area.end.x), area.position.y)  # top
		_: pos = Vector2(randf_range(area.position.x, area.end.x), area.end.y)       # bottom

	var astroid = astroid_scene.instantiate()
	astroid.position = pos
	astroid.direction = ($Player.global_position - pos).normalized()  # fly at the player
	astroid.speed = randf_range(180, 320)
	$Astroids.add_child(astroid)

func win() -> void:
	won = true
	$SpawnTimer.stop()
	for a in $Asteroids.get_children():
		a.queue_free()
	$UI/TimeLabel.text = "YOU SURVIVED!"
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
	
	#ai generated
