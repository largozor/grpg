extends StaticBody2D

class_name PuzzleResetSwitch

# Interact with this to put a puzzle's blocks back where they started

@export var blocks: Array[Block] = []

@onready var sprite = $AnimatedSprite2D
@onready var reset_sound = $ResetSound

func interact():
	for block in blocks:
		block.reset()
	reset_sound.play()
	sprite.play("on")
	await get_tree().create_timer(0.5).timeout
	sprite.play("off")
