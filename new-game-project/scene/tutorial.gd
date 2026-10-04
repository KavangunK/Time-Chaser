extends Node2D

const STEPS := [
	{"action": "right", "text": "Hold D to move forward"},
	{"action": "up", "text": "Hold W to move up"},
	{"action": "down", "text": "Hold S to move down"},
	{"action": "left", "text": "Hold A to move left"},
]

var step := 0
var held := 0.0

func _ready() -> void:
	$UI/Instruction.text = STEPS[0]["text"]

func _process(delta: float) -> void:
	if step >= STEPS.size():
		return
	# Holding the key for 0.8 seconds completes the step
	if Input.is_action_pressed(STEPS[step]["action"]):
		held += delta
		if held >= 0.3:
			held = 0.0
			step += 1
			if step < STEPS.size():
				$UI/Instruction.text = STEPS[step]["text"]
			else:
				finish()

func finish() -> void:
	$UI/Instruction.text = "Nice! Now dodge the asteroids and survive."
	await get_tree().create_timer(7.5).timeout
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
