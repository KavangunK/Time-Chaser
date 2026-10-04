extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const MAX_SPEED = 200.0
const ACCELERATION = 800.0
const FRICTION = 300.0
const SCREEN_PADDING = 40.0

var is_colliding_anim := false

func _ready() -> void:
	# Listen for when any animation finishes playing
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Only control animations if a collision animation isn't currently playing
	if not is_colliding_anim:
		if direction != Vector2.ZERO:
			animated_sprite_2d.play("flight")
		else:
			animated_sprite_2d.play("idle")
	
	# Handle movement
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# Keep the player inside the screen
	var screen := get_viewport_rect()
	global_position.x = clamp(global_position.x, screen.position.x + SCREEN_PADDING, screen.end.x - SCREEN_PADDING)
	global_position.y = clamp(global_position.y, screen.position.y + SCREEN_PADDING, screen.end.y - SCREEN_PADDING)

	# Trigger collision animation
	if move_and_slide() and not is_colliding_anim:
		is_colliding_anim = true
		animated_sprite_2d.play("death") 
		
		await get_tree().create_timer(1.0).timeout
		
		get_tree().change_scene_to_file("res://scene/death_screen.tscn")

func _on_animation_finished() -> void:
	# Unlock animation control once the hit animation ends
	if animated_sprite_2d.animation == "death":
		is_colliding_anim = false
