extends AnimatableBody2D

# add a random function to randomize speed of projectiles

@export var speed: float = 100.0
var direction: int = -1

func _physics_process(delta: float) -> void:
	# Safely moves the body and automatically updates its friction/velocity for riding players
	position.x += speed * direction * delta

# ai generated
