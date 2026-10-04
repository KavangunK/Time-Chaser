extends AnimatableBody2D

var speed := 250.0
var direction := Vector2.LEFT

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	# Delete it once it's well off-screen
	if not get_viewport_rect().grow(200).has_point(global_position):
		queue_free()
